# frozen_string_literal: true

namespace :sample_data do
  desc 'Loads sample data into the database for testing'
  task load: :environment do
    raise 'Production environment detected!' if Rails.env.production?

    # Create the admin user
    user = User.find_by(email: 'admin@localhost')
    if user.blank?
      User.create!(
        email: 'admin@localhost',
        password: 'test1234'
      )
    end

    if Flow.all.size.zero?
      # Create Flow
      flow = Flow.create!(
        name: 'Basic Flow'
      )

      # Create Actions
      delay = ENV.fetch('SAMPLE_DELAY', 1)
      # Email
      Email.create!(flow: flow, name: 'Email', delay: delay, order: 1)
      # SMS
      SMS.create!(flow: flow, name: 'SMS', delay: delay, order: 2)
      # Voicemail
      Voicemail.create!(flow: flow, name: 'Voicemail', delay: delay, order: 3)

      # Create Leads at various stages
      10.times do
        lead = Lead.create!(
          name: Faker::FunnyName.name,
          phone_number: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email
        )
        Run.create(flow: flow, lead: lead, next_action: flow.actions[rand(3)])
      end
    end
  end
end
