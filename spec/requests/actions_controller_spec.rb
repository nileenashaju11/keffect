# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Actions Controller', type: :request do
  let(:run) { create(:run) }
  let(:user) { create(:user) }
  before(:each) do
    sign_in user
  end

  describe 'reorder' do
    it 'reorders actions properly' do
      first = run.flow.actions.find_by(order: 1)
      second = run.flow.actions.find_by(order: 2)
      third = run.flow.actions.find_by(order: 3)
      put "/actions/#{second.id}/reorder", params: { order: 1 }
      # Verify database changes. Each object needs to be reloaded because the
      # object in memory is stale
      first.reload
      expect(first.order).to eq(2)
      second.reload
      expect(second.order).to eq(1)
      third.reload
      expect(third.order).to eq(3)

      put "/actions/#{second.id}/reorder", params: { order: 2 }
      first.reload
      expect(first.order).to eq(1)
      second.reload
      expect(second.order).to eq(2)
      third.reload
      expect(third.order).to eq(3)
    end

    it 'does not change order if order is the same' do
      first = run.flow.actions.find_by(order: 1)
      second = run.flow.actions.find_by(order: 2)
      third = run.flow.actions.find_by(order: 3)
      put "/actions/#{second.id}/reorder", params: { order: 2 }
      # Verify database changes. Each object needs to be reloaded because the
      # object in memory is stale
      first.reload
      expect(first.order).to eq(1)
      second.reload
      expect(second.order).to eq(2)
      third.reload
      expect(third.order).to eq(3)
    end
  end
end
