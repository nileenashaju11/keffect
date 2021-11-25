# frozen_string_literal: true

module Mindbody
  class Base
    attr_reader :connection

    def initialize
      api_key = Rails.application.credentials.dig(:mindbody, :api_key)
      @connection = Faraday.new(url: 'https://api.mindbodyonline.com') do |conn|
        conn.headers['Content-Type'] = 'application/json'
        conn.headers['Api-Key'] = api_key
        conn.headers['SiteId'] = site_id.to_s
        conn.response :json, content_type: /\bjson$/
        conn.response :json, parser_options: { object_class: OpenStruct }
        conn.response :raise_error
        conn.response :logger
        conn.adapter Faraday.default_adapter
      end
      @connection.headers['Authorization'] = issue_staff_token
    end

    ##
    # SiteId used in their api calls. -99 is used as their sandbox id.
    #
    def site_id
      return '-99' if Rails.env.test?

      Rails.application.credentials.dig(:mindbody, :site_id)
    end

    def issue_staff_token
      connection.post('/public/v6/usertoken/issue', {
        username: Rails.application.credentials.dig(:mindbody, :username),
        password: Rails.application.credentials.dig(:mindbody, :password)
      }.to_json).body.AccessToken
    end
  end
end
