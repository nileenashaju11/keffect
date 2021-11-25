# frozen_string_literal: true

module Acuity
  ##
  # The availablility endpoints in Acuity
  #
  # @todo figure out how to handle appointment_type_id and calendar_id. Maybe
  #  they are just hard coded?
  #
  class Availability < Base
    ##
    # Returns dates for the month and appointment_type_id
    #
    # @see https://developers.acuityscheduling.com/reference#get-availability-dates
    #
    def dates(month = Date.current.strftime('%Y-%m'))
      connection.get('/api/v1/availability/dates', {
                       month: month, appointmentTypeID: appointment_type_id
                     })
    end

    ##
    # Returns available times for the given date and appointment_type_id
    #
    # @see https://developers.acuityscheduling.com/reference#get-availability-times
    #
    def times(date = Date.tomorrow.strftime)
      connection.get('/api/v1/availability/times', {
                       date: date, appointmentTypeID: appointment_type_id
                     })
    end

    ##
    # Returns available classes for a given month
    #
    # @see https://developers.acuityscheduling.com/reference#get-availability-classes
    #
    def classes(month = Date.current.strftime('%Y-%m'))
      connection.get('/api/v1/availability/classes', {
                       month: month, appointment_type_id: appointment_type_id
                     })
    end

    ##
    # Validates a timeslot is available
    #
    # @see https://developers.acuityscheduling.com/reference#availability-check-times
    #
    def check_times(datetime)
      connection.post('/api/v1/availability/check-times', {
        "datetime": datetime,
        "appointmentTypeID": appointment_type_id,
        "calendarID": calendar_id
      }.to_json)
    end
  end
end
