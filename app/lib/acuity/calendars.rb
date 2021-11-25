# frozen_string_literal: true

module Acuity
  ##
  # The calendars endpoints in Acuity
  #
  # @todo figure out how to handle appointment_type_id and calendar_id. Maybe
  #  they are just hard coded?
  #
  class Calendars < Base
    ##
    # Returns calendars
    #
    # @see https://developers.acuityscheduling.com/reference#get-calendars
    #
    def all
      connection.get('/api/v1/calendars')
    end
  end
end
