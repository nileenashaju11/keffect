# frozen_string_literal: true

module Mindbody
  class Clients < Base
    ##
    # Gets all clients
    #
    # @see https://developers.mindbodyonline.com/PublicDocumentation/V6#get-clients
    #
    def all(limit: 200, offset: 0)
      connection.get('/public/v6/client/clients', { limit: limit, offset: offset }).body.Clients
    end

    ##
    # Gets a single client
    #
    # @see https://developers.mindbodyonline.com/PublicDocumentation/V6#get-clients
    #
    def get(id)
      where({ ClientIds: [id] }).first
    end

    def where(options = {})
      connection.get('/public/v6/client/clients', options).body.Clients
    end

    def create(options = {})
      connection.post('/public/v6/client/addclient', options.to_json).body.Client
    end
  end
end
