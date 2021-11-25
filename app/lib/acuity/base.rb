# frozen_string_literal: true

module Acuity
  class Base
    attr_reader :connection, :calendar_id, :appointment_type_id

    def initialize
      user_id = Rails.application.credentials.dig(:acuity, :user_id)
      api_key = Rails.application.credentials.dig(:acuity, :api_key)
      @calendar_id = 3_916_420 # Fetched from calendars endpoint
      @appointment_type_id = 14_174_288 # Fetched from appointment-types endpoint
      @connection = Faraday.new(url: 'https://acuityscheduling.com') do |conn|
        conn.request :basic_auth, user_id, api_key
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
