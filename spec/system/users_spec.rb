# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  it 'has a link to update current user in the navbar' do
    sign_in user
    visit('/')
    find('a.navbar-link', text: user.email).hover
    click_on('Settings')
    expect(page).to have_field('Email', with: user.email)
  end

  describe 'index' do
    it 'displays records' do
      sign_in user
      visit('/')
      find('a.navbar-link', text: 'Admin').hover
      click_on('Users')
      expect(page).to have_text(user.email)
    end
  end

  describe 'create' do
    it 'renders the form and saves the user' do
      sign_in user
      visit('/')
      find('a.navbar-link', text: 'Admin').hover
      click_on('Users')
      click_on('New User')
      new_user = build(:user)
      expect_any_instance_of(User).to receive(:send_reset_password_instructions)
      fill_in('Email', with: new_user.email)
      click_on('Save')
      expect(page).to have_text('Successfully created User')
      expect(page).to have_text(new_user.email)
    end
  end

  describe 'update' do
    it 'renders the form and saves the user' do
      sign_in user
      visit('/')
      find('a.navbar-link', text: 'Admin').hover
      click_on('Users')
      # Scope click to be within the table
      within('table') do
        click_on(user.email)
      end
      new_user = build(:user)
      fill_in('Email', with: new_user.email)
      click_on('Save')
      expect(page).to have_text('Successfully updated User')
    end

    it 'only renders password field if editing current user' do
      new_user = create(:user)
      sign_in user
      visit('/')
      find('a.navbar-link', text: 'Admin').hover
      click_on('Users')
      click_on(new_user.email)
      expect(page).to have_text('Email')
      expect(page).not_to have_text('Password')
    end
  end
end
