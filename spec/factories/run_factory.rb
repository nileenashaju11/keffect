# frozen_string_literal: true

FactoryBot.define do
  factory :run do
    flow factory: :flow_with_actions
    lead
    previous_action { nil }
    next_action { nil }

    after(:create) do |run, _evaluator|
      run.update(next_action: run.flow.actions.first)
    end
  end
end
