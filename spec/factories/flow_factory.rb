# frozen_string_literal: true

FactoryBot.define do
  factory :flow do
    name { Faker::FunnyName.name }
    zendesk_stage

    factory :flow_with_actions do
      transient do
        actions_count { 3 }
      end

      after(:create) do |flow, evaluator|
        evaluator.actions_count.times do |i|
          create(:action, order: i + 1, flow: flow)
        end
        flow.reload
      end
    end
  end
end
