# frozen_string_literal: true

module Front
  class Messages < Base
    attr_reader :channel_id

    def initialize(**kwargs)
      super(kwargs)
      @channel_id = kwargs[:channel_id]
    end

    ##
    # Creates a message in Front
    # @param to [String] the string where to send the message
    # @param subject [String] subject line for the message
    # @param body [String] HTML supported body for the message
    # @param text [String] plain text body for the message
    #
    def create(to, subject, body, text)
      connection.post("/channels/#{channel_id}/messages", {
        to: [to],
        subject: subject,
        body: body,
        text: text
      }.to_json)
    end

    private

    def stubbed_faraday_connection
      Faraday.new(url: 'https://api2.frontapp.com') do |conn|
        conn.authorization :Bearer, api_key
        conn.headers['Content-Type'] = 'application/json'
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :logger

        conn.adapter :test do |stub|
          stub.post("/channels/#{channel_id}/messages") do |_env|
            [
              202,
              { 'Content-Type': 'application/javascript' },
              '{}'
            ]
          end
        end
      end
    end
  end
end
