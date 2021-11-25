# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'API Leads Controller', type: :request do
  let!(:zendesk_stage) { create(:zendesk_stage, position: '1', zendesk_id: '10149837') }
  let(:params) {
    {
      "lead": {
        "first": 'Test',
        "last": 'Test',
        "email": 'test@embrk.com',
        "phone": '(801) 555-5555'
      }
    }
  }
  let(:headers) {
    {
      'Api-Key': Rails.application.credentials.dig(:api, :api_key)
    }
  }
  # Careful, this one actually makes requests
  xit 'sends data successfully to both MindBody and Google Sheets' do
    post('/api/leads', params: params, headers: headers)
    expect(response.code).to eq('200')
  end
end
