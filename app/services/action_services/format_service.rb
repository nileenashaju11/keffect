# frozen_string_literal: true

require 'action_view'

module ActionServices
  class FormatService
    include ActionView::Helpers::SanitizeHelper

    attr_accessor :run, :content

    def initialize(run, content)
      @run = run
      @content = content
    end

    def execute
      substitute_first_name
      substitute_acuity_appointment
      content
    end

    private

    def substitute_first_name
      content.gsub!('[First Name]', run.lead.first_name)
    end

    def substitute_acuity_appointment
      appointment = Appointment.upcoming.find_by(email: run.lead.email)
      # TODO: Maybe make this configurable by them
      return content.gsub!('[Acuity Appointment]', 'soon') if appointment.nil?

      # Example, Monday at 10:15am
      # %l has a leading space so we have at%l bumped up to solve the double-space
      appointment_time = appointment.starts_at.strftime('%A at%l:%M%P')
      content.gsub!('[Acuity Appointment]', appointment_time)
    end
  end
end
