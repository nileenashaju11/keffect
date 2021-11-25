# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts', type: :system do
  describe 'authentication' do
    describe 'session' do
      let(:user) { create(:user) }

      it 'signs in successfully' do
        visit('/')
        click_on('Log in')
        fill_in('Email', with: user.email)
        fill_in('Password', with: 'test1234')
        within('form') do
          click_on('Log in')
        end
        expect(page).to have_text('Signed in successfully.')
        expect(page).to have_css('.notification.is-success')
      end

      it 'requires all fields' do
        visit('/')
        click_on('Log in')
        within('form') do
          click_on('Log in')
        end
        expect(page).not_to have_text('Signed in successfully.')
        expect(page).to have_text('Invalid Email or password.')

        fill_in('Email', with: user.email)
        within('form') do
          click_on('Log in')
        end
        expect(page).not_to have_text('Signed in successfully.')
        expect(page).to have_text('Invalid Email or password.')

        fill_in('Password', with: 'test1234')
        within('form') do
          click_on('Log in')
        end
        expect(page).to have_text('Signed in successfully.')
        expect(page).not_to have_text('Invalid Email or password.')
      end

      it 'signs out successfully' do
        sign_in user

        visit('/')
        find('a.navbar-link', text: user.email).hover
        click_on('Sign out')
        expect(page).to have_text('Signed out successfully.')
        expect(page).not_to have_link('Sign out')
        expect(page).to have_link('Log in')
      end
    end
  end
end
