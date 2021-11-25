# frozen_string_literal: true

module Acuity
  ##
  # The blocks endpoints in Acuity
  #
  # @todo figure out how to handle appointment_type_id and calendar_id. Maybe
  #  they are just hard coded?
  #
  class Blocks < Base
    ##
    # Returns blocks
    #
    # @see https://developers.acuityscheduling.com/reference#blocks
    #
    def all
      connection.get('/api/v1/blocks')
    end

    def create(start_date, end_date)
      connection.post('/api/v1/blocks', {
        start: start_date,
        end: end_date,
        calendarID: calendar_id
      }.to_json)
    end
  end
end
