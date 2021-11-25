# frozen_string_literal: true

namespace :zendesk do
  desc 'Syncs data from zendesk'
  task sync: :environment do
    if ActiveModel::Type::Boolean.new.cast(Setting.zendesk_sync_enabled.value)
      zendesk = Zendesk.new
      Rails.logger.info('[ZENDESK] Beginning sync_statuses')
      zendesk.sync_statuses
      Rails.logger.info('[ZENDESK] Finished sync_statuses')
      Rails.logger.info('[ZENDESK] Beginning sync_statuses')
      zendesk.sync_stages
      Rails.logger.info('[ZENDESK] Finished sync_statuses')
      Rails.logger.info('[ZENDESK] Beginning sync_deals')
      zendesk.sync_deals
      Rails.logger.info('[ZENDESK] Finished sync_deals')
    else
      Rails.logger.warn('[ZENDESK] Sync is disabled via database')
    end
  end
end
