# frozen_string_literal: true

require 'google/apis/sheets_v4'
require 'googleauth'

class GoogleSheets
  attr_accessor :sheets

  LEADS_SPREADSHEET_ID = '1BCT7FO9xRt83yi2_U1qj0RAxvK9biIAVoDL37v8TBB0'
  FACEBOOK_LEADS_SPREADSHEET_ID = '1x_hJEjiTZAEujDTJBkJeliYtq32XmgIygiwm7bcwMMc'
  LEADS_SHEET_NAME = 'Leads sheet'
  FB_SHEET_NAME = 'FB LEADS'

  def initialize
    scope = Google::Apis::SheetsV4::AUTH_SPREADSHEETS

    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('credentials.json'),
      scope: scope
    )

    authorizer.fetch_access_token!

    @sheets = Google::Apis::SheetsV4::SheetsService.new
    @sheets.authorization = authorizer
  end

  def append_row(first_name:, last_name:, email:, phone:, time:)
    value_range_object = Google::Apis::SheetsV4::ValueRange.new(
      values: [
        [first_name, last_name, email, phone, time]
      ]
    )
    sheets.append_spreadsheet_value(
      LEADS_SPREADSHEET_ID,
      "#{LEADS_SHEET_NAME}!A1",
      value_range_object,
      value_input_option: 'RAW'
    )
  end

  def fetch_facebook_leads
    response = sheets.get_spreadsheet_values(FACEBOOK_LEADS_SPREADSHEET_ID, "#{FB_SHEET_NAME}!A2:D")
    # rubocop:disable Style/HashEachMethods
    response.values.each do |row|
      name = row[0]
      phone = row[1]
      email = row[2]
      submitted_at = row[3]

      begin
        LeadService.new(
          name: name,
          phone: phone,
          email: email,
          submitted_at: submitted_at,
          referred_by: 'Facebook'
        ).execute
      rescue Faraday::ClientError, Google::Apis::ClientError, Google::Apis::AuthorizationError, BaseCRM::ErrorsCollection
        Rails.logger.error("[GOOGLE SHEETS] Error sending data to third parties. #{name}, #{phone}, #{email}, #{submitted_at}")
        next
      end
    end
    # rubocop:enable Style/HashEachMethods
  end
end
