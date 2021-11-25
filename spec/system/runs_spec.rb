# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Runs', type: :system do
  let(:user) { create(:user) }
  before(:each) do
    sign_in user
  end

  let!(:run) { create(:run) }
  let(:flow) { run.flow }

  describe 'canceling' do
    it 'cancels the run' do
      # Stub response since job is not actually queued in test
      allow(Sidekiq::Status).to receive(:cancel).
        with(run.scheduled_job_id).and_return(true)

      visit('/')
      click_on(flow.name)
      expect(page).to have_text(flow.name)
      expect(page).to have_text('Runs')
      within("tr[data-run-id='#{run.id}']") do
        click_on('Cancel')
        page.accept_alert
      end
      expect(page).to have_text('Run successfully cancelled.')
    end
  end

  describe 'resuming' do
    before do
      # Set the run to not be in progress
      run.update(scheduled_job_id: nil)
    end

    it 'resumes the run' do
      expect(run.scheduled_job_id).to eq(nil)
      visit('/')
      click_on(flow.name)
      expect(page).to have_text(flow.name)
      expect(page).to have_text('Runs')
      within("tr[data-run-id='#{run.id}']") do
        click_on('Resume')
        page.accept_alert
      end
      expect(page).to have_text('Run successfully resumed.')
      run.reload
      expect(run.scheduled_job_id).not_to eq(nil)
    end
  end
end
