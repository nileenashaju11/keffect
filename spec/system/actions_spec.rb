# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Actions', type: :system do
  let(:user) { create(:user) }
  before(:each) do
    sign_in user
  end

  describe 'creating' do
    let!(:flow) { create(:flow) }
    let(:action) { build(:email) }

    it 'creates a new action' do
      visit('/')
      click_on(flow.name)
      click_on('New Action')
      fill_in('Name', with: action.name)
      fill_in('Subject', with: action.subject)
      click_on('Save')
      expect(page).to have_text('Action successfully created.')
      expect(page).to have_text(action.name)
    end

    it 'creates an action of a specific type' do
      visit('/')
      click_on(flow.name)
      click_on('New Action')
      fill_in('Name', with: action.name)
      select('Voicemail', from: 'Type')
      expect(page).not_to have_text('Subject')
      attach_file('Audio file', Rails.root.join('spec/fixtures/audio/test.mp3'))
      click_on('Save')
      expect(page).to have_text('Action successfully created.')
      expect(page).to have_text('Voicemail')
      action = flow.actions.last
      expect(action.class).to eq(Voicemail)
    end
  end

  context 'existing object' do
    let!(:action) { create(:email) }
    let(:flow) { action.flow }

    describe 'show' do
      it 'displays information' do
        visit('/')
        click_on(flow.name)
        expect(page).to have_text(action.name)
      end
    end

    describe 'editing' do
      it 'edits an action' do
        visit('/')
        click_on(flow.name)
        within("tr[data-action-id='#{action.id}'") do
          click_on('Edit')
        end
        new_text = Faker::Hipster.sentence
        fill_in('Name', with: new_text)
        click_on('Save')
        expect(page).to have_text('Action successfully updated.')
        expect(page).to have_text(new_text)
        # Verify database
        action.reload
        expect(action.name).to eq(new_text)
      end

      it 'changes type' do
        # Store variables for testing database changes later
        initial_class = action.class
        id = action.id
        visit('/')
        click_on(flow.name)
        within("tr[data-action-id='#{action.id}'") do
          click_on('Edit')
        end
        select('Voicemail', from: 'Type')
        attach_file('Audio file', Rails.root.join('spec/fixtures/audio/test.mp3'))
        click_on('Save')
        expect(page).to have_text('Action successfully updated.')
        # Verify database changes
        action = Action.find(id)
        expect(action.class).to eq(Voicemail)
        expect(action.class).not_to eq(initial_class)

        # Try again
        visit('/')
        click_on(flow.name)
        within("tr[data-action-id='#{action.id}'") do
          click_on('Edit')
        end
        select('SMS', from: 'Type')
        click_on('Save')
        expect(page).to have_text('Action successfully updated.')
        action = Action.find(id)
        expect(action.class).not_to eq(Voicemail)
      end
    end

    describe 'destroying' do
      it 'deletes the action' do
        visit('/')
        click_on(flow.name)
        within("tr[data-action-id='#{action.id}'") do
          click_on('Remove')
          page.accept_alert
        end
        expect(page).to have_text('Action Successfully removed.')
        expect(page).not_to have_text(action.subject)
      end
    end
  end
end
