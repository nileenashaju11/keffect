# frozen_string_literal: true

module Slybroadcast
  class Base
    attr_reader :connection, :api_key

    def initialize(**kwargs)
      @connection = kwargs[:connection] || faraday_connection
    end

    ##
    # We only want to truly send voicemails in production and when testing in
    # development. To help with that this method contains the logic around
    # initializing either a true Faraday connection object or a stubbed one.
    # This can be customized in the inherited classes
    #
    def faraday_connection
      return production_faraday_connection if Rails.env.production? ||
                                              ActiveModel::Type::Boolean.new.cast(ENV['ENABLE_SLYBROADCAST'])

      stubbed_faraday_connection
    end

    private

    def production_faraday_connection
      Faraday.new(url: 'https://www.slybroadcast.com') do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end

    ##
    # Returns a stubbed Faraday connection to help not make requests in development
    #
    def stubbed_faraday_connection
      Faraday.new(url: 'https://www.slybroadcast.com') do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :logger

        conn.adapter :test do |stub|
          stub.get('/') do |_env|
            [
              200,
              { 'Content-Type': 'application/json', },
              '{}'
            ]
          end
        end
      end
    end
  end
end
