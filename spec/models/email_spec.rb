# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Email, type: :model do
  let(:run) { create(:run) }
  let(:email) { create(:email) }

  it_behaves_like 'an Action'

  describe 'execute' do
    before(:each) do
      ActiveSupport.run_load_hooks :action_text_content, ActionText::Content
    end

    it 'sends up an email' do
      expect_any_instance_of(Front::Messages).to receive(:create).and_return(Faraday::Response.new(status: 202))
      expect(email.execute(run: run).success?).to eq(true)
    end
  end
end
