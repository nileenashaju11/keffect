# frozen_string_literal: true

FactoryBot.define do
  factory :zendesk_stage do
    name { Faker::TvShows::Simpsons.character }
    position { Faker::Number.non_zero_digit }
    zendesk_id { rand(1..10_000) }
  end
end
