# frozen_string_literal: true

module Front
  class Channels < Base
    ##
    # Gets all channels
    #
    # @return Faraday::Response
    #
    def all
      connection.get('/channels')
    end

    private

    ##
    # Stubbed Faraday connection for testing
    #
    def stubbed_faraday_connection
      Faraday.new(url: 'https://api2.frontapp.com') do |conn|
        conn.authorization :Bearer, api_key
        conn.headers['Content-Type'] = 'application/json'
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :logger

        conn.adapter :test do |stub|
          stub.get('/channels') do |_env|
            [
              200,
              { 'Content-Type': 'application/javascript' },
              '{}'
            ]
          end
        end
      end
    end
  end
end
