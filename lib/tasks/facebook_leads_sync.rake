# frozen_string_literal: true

namespace :facebook_leads do
  desc 'Syncs data from a Google Sheet that contains Facebook leads'
  task sync: :environment do
    Rails.logger.info('[FACEBOOK LEADS] Fetching leads from Google Sheet')
    sheets = GoogleSheets.new
    sheets.fetch_facebook_leads
    Rails.logger.info('[FACEBOOK LEADS] Finished syncing leads')
  end
end
