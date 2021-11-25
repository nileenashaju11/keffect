# frozen_string_literal: true

FactoryBot.define do
  factory :zendesk_status do
    status { Faker::TvShows::Simpsons.character }
  end
end
