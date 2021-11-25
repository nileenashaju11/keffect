# frozen_string_literal: true

module Front
  class Base
    attr_reader :connection, :api_key

    def initialize(**kwargs)
      @api_key = Rails.application.credentials.dig(:front, :api_key)
      @connection = kwargs[:connection] || faraday_connection
    end

    ##
    # We only want to truly send emails in production and when testing in
    # development. To help with that this method contains the logic around
    # initializing either a true Faraday connection object or a stubbed one.
    # This can be customized in the inherited classes
    #
    def faraday_connection
      return production_faraday_connection if Rails.env.production? ||
                                              ActiveModel::Type::Boolean.new.cast(ENV['ENABLE_FRONT'])

      stubbed_faraday_connection
    end

    private

    def production_faraday_connection
      Faraday.new(url: 'https://api2.frontapp.com') do |conn|
        conn.authorization :Bearer, api_key
        conn.headers['Content-Type'] = 'application/json'
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
      Faraday.new(url: 'https://api2.frontapp.com') do |conn|
        conn.authorization :Bearer, api_key
        conn.headers['Content-Type'] = 'application/json'
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
