# frozen_string_literal: true

FactoryBot.define do
  factory :lead do
    name { Faker::FunnyName.name }
    phone_number { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
  end
end
