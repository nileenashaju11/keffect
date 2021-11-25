# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Leads', type: :system do
  let(:user) { create(:user) }
  before(:each) do
    sign_in user
  end

  describe 'creating' do
    let(:lead) { build(:lead) }

    it 'creates a new lead' do
      visit('/')
      click_on('Leads')
      click_on('New Lead')
      fill_in('Name', with: lead.name)
      fill_in('Phone number', with: lead.phone_number)
      fill_in('Email', with: lead.email)
      click_on('Save')
      expect(page).to have_text('Successfully created Lead')
      expect(page).to have_text(lead.name)
      expect(page).to have_text(format_phone_number(lead.phone_number.tr('^0-9', '')))
      expect(page).to have_text(lead.email)
    end
  end

  context 'existing object' do
    let!(:lead) { create(:lead) }

    describe 'show' do
      it 'displays information' do
        visit('/')
        click_on('Leads')
        click_on(lead.name)
        expect(page).to have_text(lead.name)
      end
    end

    describe 'editing' do
      it 'edits a lead' do
        visit('/')
        click_on('Leads')
        click_on(lead.name)
        click_on('Edit Lead')
        new_name = Faker::FunnyName.name
        fill_in('Name', with: new_name)
        click_on('Save')
        expect(page).to have_text('Successfully updated Lead')
        expect(page).to have_field('Name', with: new_name)
        # Verify database
        lead.reload
        expect(lead.name).to eq(new_name)
      end
    end

    describe 'destroying' do
      it 'deletes the lead' do
        visit('/')
        click_on('Leads')
        within("tr[data-lead-id='#{lead.id}']") do
          click_on('Remove')
          page.accept_alert
        end
        expect(page).to have_text('Successfully removed Lead')
        expect(page).not_to have_text(lead.name)
      end
    end
  end
end
