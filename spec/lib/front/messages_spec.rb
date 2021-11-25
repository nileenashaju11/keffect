# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Front::Messages, type: :lib do
  let(:action) { create(:action) }
  let(:channel_id) { '123456' }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:subject) { described_class.new(connection: connection, channel_id: channel_id) }

  describe 'all' do
    it 'returns all channels' do
      # Stub request because we don't actually want to make a request
      stubs.post("/channels/#{channel_id}/messages") do |env|
        expect(env.url.path).to eq("/channels/#{channel_id}/messages")
        [
          202,
          { 'Content-Type': 'application/javascript' },
          file_fixture('front/messages/create.json').to_s
        ]
      end
      # Reload the action text content, this was causing a flaky thread issue
      # when the renderer is used in another test
      ActiveSupport.run_load_hooks :action_text_content, ActionText::Content

      expect(subject.create(
               'test@example.com',
               'Test',
               action.content.body.to_s,
               action.content.body.to_plain_text
             )).to be_success
    end
  end
end
