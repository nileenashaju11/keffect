# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Run, type: :model do
  let(:flow) { create(:flow_with_actions) }
  let(:lead) { create(:lead) }
  let(:run) { create(:run, flow: flow, lead: lead) }

  describe 'callbacks' do
    let(:run) { build(:run) }

    context 'before_create' do
      it 'calls set_first_action' do
        expect(run).to receive(:set_first_action)
        run.save
      end
    end

    context 'after_create' do
      it 'calls queue_next_action' do
        expect(run).to receive(:queue_next_action)
        run.save
      end
    end
  end

  describe 'queue_next_action' do
    it 'creates an ActionWorker with next_action' do
      run # initializes the object and runs hooks
      expect { run.queue_next_action }.to change(ActionWorker.jobs, :size).by(1)
    end

    it 'stores the scheduled_job_id' do
      expect { run.queue_next_action }.to(change { run.scheduled_job_id })
    end
  end

  describe 'set_first_action' do
    it 'sets to first action in flow' do
      # initialize to something we know to not be the correct action
      run.update(next_action: nil)
      # run explicitly via send
      run.send(:set_first_action)
      expect(run.next_action_id).not_to be(nil)
      expect(run.next_action_id).to eq(flow.actions.first.id)
      expect(run.next_action.order).to eq(1)
    end

    it 'is triggered on create' do
      run = build(:run, flow: flow, lead: lead)
      expect(run.next_action).to eq(nil)
      run.save
      expect(run.next_action).to eq(flow.actions.first)
      expect(run.next_action.order).to eq(1)
    end
  end

  describe 'cancel_scheduled_action' do
    # Currently not functional due to a lack of support in Sidekiq::Status
    # @see https://github.com/utgarda/sidekiq-status/issues/63
    xit 'removes from queue' do
      run
      expect(ActionWorker.jobs.size).to eq 1
      expect(run.cancel_scheduled_action).to eq(true)
      expect(ActionWorker.jobs.size).to eq 0
    end
  end
end
