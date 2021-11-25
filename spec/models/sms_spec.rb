# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SMS, type: :model do
  let(:run) { create(:run) }
  let(:sms) { create(:sms) }

  it_behaves_like 'an Action'

  describe 'execute' do
    before(:each) do
      ActiveSupport.run_load_hooks :action_text_content, ActionText::Content
    end

    it 'sends an SMS' do
      expect_any_instance_of(Front::Messages).to receive(:create).and_return(Faraday::Response.new(status: 202))
      expect(sms.execute(run: run).success?).to eq(true)
    end
  end
end
