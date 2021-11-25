# frozen_string_literal: true

require 'basecrm'

class Zendesk
  attr_accessor :client

  def initialize
    @client = BaseCRM::Client.new(
      access_token: Rails.application.credentials.dig(:zendesk, :access_token)
    )
  end

  ##
  # Fetches all leads where the status is 'New'
  #
  def new_leads
    client.leads.where(status: 'New')
  end

  ##
  # Fetches all new leads and creates them in our database if we don't
  # already have them
  #
  def sync_new_leads
    # Loop through new leads
    new_leads.each do |lead|
      # Skip if we already have the lead
      next if Lead.find_by(zendesk_id: lead.id.to_s).present?

      # Create lead in our database
      Lead.create(
        name: "#{lead.first_name} #{lead.last_name}",
        phone_number: lead.mobile.delete('^0-9'),
        email: lead.email,
        zendesk_id: lead.id
      )
      # Update Zendesk status to reflect lead nurturer save
      # lead.update(status: 'Entered Lead Machine')
    end
  end

  def new_deals
    first_deal_stage = ZendeskStage.find_by(position: 1)
    client.deals.where(stage_id: first_deal_stage.zendesk_id)
  end

  def sync_new_deals
    # Loop through new deals
    new_deals.each do |deal|
      # Skip if we already have the deal
      next if Lead.find_by(zendesk_id: deal.id.to_s).present?

      # Create deal in our database
      contact = client.contacts.find(deal.contact_id)
      Lead.create(
        name: "#{contact.first_name} #{contact.last_name}",
        phone_number: contact.mobile&.delete('^0-9'),
        email: contact.email,
        zendesk_id: deal.id
      )
      # Update Zendesk status to reflect lead nurturer save
      # deal.update(status: 'Entered Lead Machine')
    end
  end

  ##
  # Syncs all deals from Zendesk and puts them into whatever flow is needed
  #
  def sync_deals
    client.deals.all.each do |zendesk_deal|
      lead = Lead.find_by(zendesk_id: zendesk_deal.id.to_s)
      zendesk_stage = ZendeskStage.find_by(zendesk_id: zendesk_deal.stage_id)
      if lead.nil?
        # Create deal in our database
        contact = client.contacts.find(zendesk_deal.contact_id)
        Lead.create(
          name: "#{contact.first_name} #{contact.last_name}",
          phone_number: contact.mobile&.delete('^0-9'),
          email: contact.email,
          zendesk_id: zendesk_deal.id,
          zendesk_stage: zendesk_stage
        )
      elsif lead.zendesk_stage != zendesk_stage
        # Update zendesk stage
        lead.update(zendesk_stage: zendesk_stage)
        # Cancel any current runs
        lead.cancel_current_runs
        # Start a new run via flow
        lead.async_enter_flow
      end
      # Update Zendesk status to reflect lead nurturer save
      # deal.update(status: 'Entered Lead Machine')
    end
  end

  ##
  # Sync statuses
  #
  def sync_statuses
    statuses = client.leads.all.map(&:status).uniq
    statuses.each do |status|
      ZendeskStatus.find_or_create_by(status: status)
    end
  end

  ##
  # Sync stages
  #
  def sync_stages
    stages.each do |stage|
      zendesk_stage = ZendeskStage.find_or_initialize_by(zendesk_id: stage.id)
      zendesk_stage.name = stage.name
      zendesk_stage.position = stage.position
      zendesk_stage.save
    end
  end

  ##
  # Get all stages
  #
  def stages
    # This is the sales pipeline id, it may be brittle hard coding the ID here
    sales_pipeline_id = 1_218_467

    client.stages.where(pipeline_id: sales_pipeline_id)
  end
end
