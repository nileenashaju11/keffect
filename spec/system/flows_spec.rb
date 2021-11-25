# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flows', type: :system do
  let(:user) { create(:user) }
  before(:each) do
    sign_in user
  end

  describe 'creating' do
    let!(:zendesk_stage) { create(:zendesk_stage) }
    let(:flow) { build(:flow) }

    it 'creates a new flow' do
      visit('/')
      click_on('New Flow')
      fill_in('Name', with: flow.name)
      select(zendesk_stage.name, from: 'Zendesk stage')
      click_on('Save')
      expect(page).to have_text('Successfully created Flow')
      expect(page).to have_text(flow.name)
    end
  end

  context 'existing object' do
    let!(:flow) { create(:flow) }

    describe 'show' do
      it 'displays information' do
        visit('/')
        click_on(flow.name)
        expect(page).to have_text(flow.name)
      end
    end

    describe 'editing' do
      it 'edits a flow' do
        visit('/')
        click_on(flow.name)
        click_on('Edit Flow')
        new_name = Faker::FunnyName.name
        fill_in('Name', with: new_name)
        click_on('Save')
        expect(page).to have_text('Successfully updated Flow')
        expect(page).to have_text(new_name)
        # Verify database
        flow.reload
        expect(flow.name).to eq(new_name)
      end
    end

    describe 'destroying' do
      it 'deletes the flow' do
        visit('/')
        within("tr[data-flow-id='#{flow.id}']") do
          click_on('Remove')
          page.accept_alert
        end
        expect(page).to have_text('Successfully removed Flow')
        expect(page).not_to have_text(flow.name)
      end
    end
  end
end
