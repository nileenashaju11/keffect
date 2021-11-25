# frozen_string_literal: true

module Mindbody
  class GymClasses < Base
    ##
    # Gets all classes
    #
    def all
      where
    end

    ##
    # Filters classes. The defaults are there because the filter defaults to
    # only search clases with today's date but that isn't intuitive
    #
    # @see https://developers.mindbodyonline.com/PublicDocumentation/V6?ruby#get-classes
    #
    def where(options = {})
      defaults = { StartDateTime: Time.zone.at(0), EndDateTime: 100.years.from_now }
      options.reverse_merge!(defaults)
      connection.get('/public/v6/class/classes', options).body.Classes
    end

    def get(id)
      where({ ClassIds: [id] })
    end

    def schedules
      connection.get('/public/v6/class/classschedules')
    end

    def add_client_to_class(client_id, class_id)
      connection.post('/public/v6/class/addclienttoclass', {
        ClientId: client_id,
        ClassId: class_id
      }.to_json )
    end
  end
end
