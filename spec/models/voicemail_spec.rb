# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voicemail, type: :model do
  let(:run) { create(:run) }
  let(:voicemail) { create(:voicemail) }

  it_behaves_like 'an Action'

  describe 'execute' do
    it 'executes successfully' do
      allow_any_instance_of(Voicemail).to receive(:execute).and_return(Faraday::Response.new(status: 202))
      voicemail.execute(run: run)
    end
  end
end
