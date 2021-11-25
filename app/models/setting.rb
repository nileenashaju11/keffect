# frozen_string_literal: true

class Setting < ApplicationRecord
  validates :key, uniqueness: { case_sensitive: false }

  def self.blackout_hours_start
    find_or_create_by(key: 'blackout_hours_start')
  end

  def self.blackout_hours_end
    find_or_create_by(key: 'blackout_hours_end')
  end

  def self.zendesk_sync_enabled
    zendesk_sync = find_or_create_by(key: 'zendesk_sync_enabled')
    zendesk_sync.update(value: true) if zendesk_sync.value.nil?
    zendesk_sync
  end

  def self.acuity_to_mindbody_sync_enabled
    acuity_to_mindbody_sync = find_or_create_by(key: 'acuity_to_mindbody_sync')
    acuity_to_mindbody_sync.update(value: true) if acuity_to_mindbody_sync.value.nil?
    acuity_to_mindbody_sync
  end

  def self.mindbody_to_acuity_sync_enabled
    mindbody_to_acuity_sync = find_or_create_by(key: 'mindbody_to_acuity_sync')
    mindbody_to_acuity_sync.update(value: true) if mindbody_to_acuity_sync.value.nil?
    mindbody_to_acuity_sync
  end

  def self.automatically_start_new_runs_enabled
    automatically_start_new_runs = find_or_create_by(key: 'automatically_start_new_runs')
    automatically_start_new_runs.update(value: true) if automatically_start_new_runs.value.nil?
    automatically_start_new_runs
  end
end
