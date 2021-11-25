# frozen_string_literal: true

# Join object between a Flow and a Lead to manage how the Lead is going through
# the Flow
class Run < ApplicationRecord
  include Historical

  belongs_to :flow
  belongs_to :lead
  belongs_to :previous_action, class_name: 'Action', optional: true
  belongs_to :next_action, class_name: 'Action', optional: true
  has_many :actions, through: :flow

  before_create :set_first_action
  after_create :queue_next_action

  ##
  # Adds the execution of the next action to the background processor to be run
  # `next_action.delay.minutes` from now
  #
  def queue_next_action
    return if next_action.nil?

    scheduled_job_id = ActionWorker.perform_in(next_action.perform_at, id)
    update(scheduled_job_id: scheduled_job_id)
    record_history("#{next_action.type} scheduled to send in #{next_action.delay} minutes at #{next_action.delay.minutes.from_now.to_formatted_s(:long)}.")
  end

  ##
  # Executes the next_action and then updates the pointers if execution was
  # successful
  #
  def execute_next_action
    return if next_action.nil?

    result = next_action.execute(run: self)
    if result.success?
      record_history("#{next_action.type} successfully sent.")
      update(
        previous_action: next_action,
        next_action: actions.find_by(order: next_action.order + 1),
        scheduled_job_id: nil
      )
    else
      record_history("#{next_action.type} failed to send. #{result.error}")
    end
    queue_next_action
    result
  end

  ##
  # Cancels the scheduled action
  #
  def cancel_scheduled_action
    canceled = Sidekiq::Status.cancel(scheduled_job_id)
    missing = Sidekiq::Status.status(scheduled_job_id).nil?
    if canceled || missing
      update(scheduled_job_id: nil)
      record_history("#{next_action&.type} canceled.")
      return true
    end
    false
  end

  private

  ##
  # Sets the first Action to be executed
  #
  def set_first_action
    self.next_action ||= flow.actions.first
  end
end
