# frozen_string_literal: true

# Leads represent a person from the CRM
class Lead < ApplicationRecord
  include Historical

  has_many :runs, inverse_of: :lead, dependent: :destroy
  has_many :flows, through: :runs, dependent: :destroy
  belongs_to :zendesk_stage, optional: true

  before_save :clean_phone_number
  before_save :downcase_email
  after_commit :async_enter_flow, on: :create

  ##
  # Queues up running the Flow for the Lead
  #
  def async_enter_flow
    EnterFlowWorker.perform_async(id)
  end

  ##
  # Puts Lead into a Flow via a Run
  #
  def enter_flow(flow)
    Run.create(flow: flow, lead: self)
  end

  ##
  # Cancels all current runs for the lead
  #
  def cancel_current_runs
    runs.where.not(scheduled_job_id: nil).find_each(&:cancel_scheduled_action)
  end

  ##
  # Helper method to display first name of the lead
  #
  def first_name
    name.split.first
  end

  def zendesk
    return nil if zendesk_id.nil?

    Zendesk.new.client.deals.find(zendesk_id)
  end

  def appointments
    Appointment.where(email: email)
  end

  private

  ##
  # Cleans all characters other than integers from the phone_number field
  #
  def clean_phone_number
    self.phone_number = phone_number&.tr('^0-9', '')
  end

  ##
  # Downcases the email for consistency
  #
  def downcase_email
    self.email = email.downcase
  end
end
