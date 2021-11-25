# frozen_string_literal: true

module Acuity
  class Appointments < Base
    ##
    # Gets all appointments
    #
    # @return Faraday::Response
    #
    def all(min_date = Time.current.to_s)
      connection.get('/api/v1/appointments', { minDate: min_date })
    end

    ##
    # Creates an appointment
    #
    def create(datetime, first_name, last_name, email)
      connection.post('/api/v1/appointments', {
                        datetime: datetime,
                        appointmentTypeID: appointment_type_id,
                        firstName: first_name,
                        lastName: last_name,
                        email: email
                      })
    end

    ##
    # Fetches an appointment
    #
    # @see https://developers.acuityscheduling.com/reference#get-appointments-id
    #
    def get(id)
      connection.get("/api/v1/appointments/#{id}")
    end

    ##
    # Cancelles an appointment
    #
    def cancel(id)
      # TODO
    end

    ##
    # Cancelles an appointment
    #
    def reschedule(id)
      # TODO
    end

    def appointment_types
      connection.get('/api/v1/appointment-types')
    end
  end
end
