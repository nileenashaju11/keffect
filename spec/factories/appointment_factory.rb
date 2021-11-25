# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    email { 'test@test.com' }
    acuity_appointment_id { 1 }
    mindbody_class_id { 1 }
    starts_at { 1.day.from_now }
  end
end
