# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lead, type: :model do
  let(:lead) { create(:lead) }

  it_behaves_like 'Historical'

  describe 'callbacks' do
    context 'after_commit' do
      let(:lead) { build(:lead) }
      describe '#async_enter_flow' do
        it 'only triggers on create' do
          expect(lead).to receive(:async_enter_flow)
          lead.save
          expect(lead).not_to receive(:async_enter_flow)
          lead.save
        end
      end
    end
  end

  describe '#enter_flow' do
    let(:flow) { create(:flow) }
    it 'creates a run with the given flow' do
      expect { lead.enter_flow(flow) }.to change { Run.count }.from(0).to(1)
      run = Run.last
      expect(run.flow).to eq(flow)
      expect(run.lead).to eq(lead)
    end
  end
end
