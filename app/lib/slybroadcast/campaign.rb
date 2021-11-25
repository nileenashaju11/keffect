# frozen_string_literal: true

module Slybroadcast
  class Campaign < Base
    def create(phone_number, audio_url, audio_type)
      response = connection.post('/gateway/vmb.json.php', {
                                   c_method: 'new_campaign',
                                   c_phone: phone_number,
                                   c_uid: Rails.application.credentials.dig(:slybroadcast, :email),
                                   c_password: Rails.application.credentials.dig(:slybroadcast, :password),
                                   c_date: 'now',
                                   c_url: audio_url,
                                   c_audio: audio_type
                                 })
      # Their API always returns a 200 even if there is an error. Here
      # we return a failing Faraday::Response object to keep things consistent
      return response if response.body.ERROR.blank?

      Faraday::Response.new(body: response.body, status: 400)
    end

    private

    def stubbed_faraday_connection
      Faraday.new(url: 'https://www.slybroadcast.com') do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :logger

        conn.adapter :test do |stub|
          stub.post('/gateway/vmb.json.php') do |_env|
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
