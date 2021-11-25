# frozen_string_literal: true

FactoryBot.define do
  factory :action do
    flow
    name { Faker::Hipster.word }
    subject { Faker::Hipster.sentence }

    after(:create) { |action| action.create_rich_text_content(body: 'test') }

    factory :email, parent: :action, class: 'Email'
    factory :sms, parent: :action, class: 'SMS'
    factory :voicemail, parent: :action, class: 'Voicemail' do
      audio_file {
        Rack::Test::UploadedFile.new(
          Rails.root.join('spec/fixtures/audio/test.mp3'),
          'audio/mp3'
        )
      }
    end
  end
end
