# frozen_string_literal: true

class LeadService
  include ActionView::Helpers::SanitizeHelper

  attr_accessor :name, :phone, :email, :submitted_at, :referred_by, :zendesk_contact, :zendesk_deal, :zendesk_stage

  def initialize(name:, phone:, email:, submitted_at: nil, referred_by: 'Lead Machine')
    @name = name
    @phone = phone
    @email = email.downcase
    @submitted_at = submitted_at
    @referred_by = referred_by
  end

  def execute
    # Skip if we already have the lead
    return true if Lead.find_by(email: email).present?

    ActiveRecord::Base.transaction do
      # Mindbody
      find_or_create_in_mindbody
      # Zendesk
      find_or_create_in_zendesk
      # Create Lead in database
      create_lead
      # Google Sheets
      send_to_google_sheets
    end
  end

  ##
  # Send lead to Google Sheet
  #
  def send_to_google_sheets
    google_sheets = GoogleSheets.new
    google_sheets.append_row(
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone: phone,
      time: submitted_at || Time.current.to_s
    )
  end

  ##
  # Creates lead in our database. Relies on data from zendesk so calls #find_or_create_in_zendesk
  # if variables are missing
  #
  def create_lead
    find_or_create_in_zendesk if [zendesk_contact, zendesk_deal, zendesk_stage].any?(&:nil?)

    Lead.create!(
      name: "#{zendesk_contact.first_name} #{zendesk_contact.last_name}",
      phone_number: zendesk_contact.mobile&.delete('^0-9'),
      email: zendesk_contact.email,
      zendesk_id: zendesk_deal.id,
      zendesk_stage: zendesk_stage
    )
  end

  ##
  # Find or create contact in Mindbody
  #
  def find_or_create_in_mindbody
    mind_body = Mindbody::Clients.new

    mindbody_client = mind_body.where({ SearchText: email }).first
    # Create mindbody client if needed
    # BirthDate is not required on their client config but the API is
    # still requiring it for some reason. We are defaulting it to epoch
    return mindbody_client if mindbody_client.present?

    # BirthDate is not required on their client config but the API is
    # still requiring it for some reason. We are defaulting it to epoch
    mind_body.create({
                       FirstName: first_name,
                       LastName: last_name,
                       Email: email,
                       MobilePhone: phone,
                       BirthDate: Time.zone.at(0).to_s,
                       ReferredBy: referred_by
                     })
  end

  ##
  # Find or create in Zendesk. Creates both the Contact and Deal
  #
  def find_or_create_in_zendesk
    zendesk = Zendesk.new
    @zendesk_contact = zendesk.client.contacts.where(email: email).first
    # If we can't find the contact we create
    if @zendesk_contact.nil?
      @zendesk_contact = zendesk.client.contacts.create(
        name: name,
        first_name: first_name,
        last_name: last_name,
        email: email,
        mobile: phone
      )
    end
    # This is the opening deal stage, we assume coming in the API they will start here
    @zendesk_stage = ZendeskStage.find_by(position: 1)
    # Create deal for contact
    @zendesk_deal = zendesk.client.deals.create(
      name: name,
      contact_id: @zendesk_contact.id,
      stage_id: @zendesk_stage&.zendesk_id.to_i
    )
    [@zendesk_contact, @zendesk_deal, @zendesk_stage]
  end

  ##
  # Helper method for splitting a name and getting the first part
  #
  def first_name
    name.split.first
  end

  ##
  # Helper method for splitting a name and getting the last part
  #
  def last_name
    name.split[1..].join(' ')
  end
end
