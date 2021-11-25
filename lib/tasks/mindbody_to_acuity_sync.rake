# frozen_string_literal: true

namespace :mindbody_to_acuity do
  desc 'Syncs data from Mindbody to Acuity'
  task sync: :environment do
    if ActiveModel::Type::Boolean.new.cast(Setting.mindbody_to_acuity_sync_enabled.value)
      Rails.logger.info('[MINDBODY] Fetching classes')
      classes = Mindbody::GymClasses.new.all
      acuity_blocks = Acuity::Blocks.new
      Rails.logger.info('[MINDBODY] Finished fetching classes')
      Rails.logger.info('[ACUITY] Syncing classes')
      classes.each do |gym_class|
        next unless gym_class.MaxCapacity <= gym_class.TotalBooked

        # Block out acuity time if class is full
        acuity_blocks.create(gym_class.StartDateTime, gym_class.EndDateTime)
      end
      Rails.logger.info('[ACUITY] Finished syncing classes')
    else
      Rails.logger.warn('[MINDBODY TO ACUITY] Disabled via admin.')
    end
  end
end
