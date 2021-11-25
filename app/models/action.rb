# frozen_string_literal: true

# An Action is one that does something. Normally this will be notifying the
# lead in some way of something.
class Action < ApplicationRecord
  include Historical

  belongs_to :flow
  has_rich_text :content

  validates :delay, numericality: { greater_than_or_equal_to: 0 }

  before_create :set_order

  ##
  # Execute is the base command of an Action. It should be overwritten on
  # any class that inherits from this
  #
  def execute(**_kwargs)
    OpenStruct.new(success?: true)
  end

  ##
  # Helper method for displaying the action as html
  #
  def display_html
    content&.body&.to_s
  end

  ##
  # Helper method for displaying the action as plain text
  #
  def display_plain_text
    content&.body&.to_plain_text
  end

  ##
  # Helper method for returning when to perform the action scheduling around
  # blackout times
  #
  def perform_at
    perform_time = delay_until

    blackout_hours_start = Setting.blackout_hours_start.value &&
                           DateTime.parse(Setting.blackout_hours_start.value)
    blackout_hours_end = Setting.blackout_hours_end.value &&
                         DateTime.parse(Setting.blackout_hours_end.value)

    # If either blackout hours start or end is nil we can't calculate the delay
    # properly so we just return the origin perform_time
    if blackout_hours_start.nil? || blackout_hours_end.nil?
      return perform_time
    end

    # Convert blackout hours to a Time object
    blackout_hours_start = Time.zone.parse(blackout_hours_start.strftime('%H:%M'))
    blackout_hours_end = Time.zone.parse(blackout_hours_end.strftime('%H:%M'))

    # If the next action will be performed after blackout hours we set it ahead
    # to when blackout hours end
    parsed_perform_time = perform_time
    parsed_blackout_hours_start = parsed_perform_time.change(hour: blackout_hours_start.hour, min: blackout_hours_start.min)
    parsed_blackout_hours_end = parsed_perform_time.change(hour: blackout_hours_end.hour, min: blackout_hours_end.min)
    # Handle time across days
    if parsed_blackout_hours_end < parsed_blackout_hours_start
      if parsed_perform_time > parsed_blackout_hours_end
        parsed_blackout_hours_end += 1.day
      else
        parsed_blackout_hours_start -= 1.day
      end
    end

    if parsed_perform_time.between?(parsed_blackout_hours_start, parsed_blackout_hours_end)
      parsed_blackout_hours_end
    else
      parsed_perform_time
    end
  end

  ##
  # Helper method for converting +delay+ to a DateTime object
  #
  def delay_until
    delay.minutes.from_now
  end

  private

  ##
  # Order is defined as the sequence in which actions are run. set_order
  # increments the size of the actions by 1
  #
  def set_order
    self.order ||= flow.actions.size + 1
  end
end
