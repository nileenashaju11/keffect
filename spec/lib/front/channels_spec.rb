# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Front::Channels, type: :lib do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:subject) { described_class.new(connection: connection) }

  describe 'all' do
    it 'returns all channels' do
      # Stub request because we don't actually want to make a request
      stubs.get('/channels') do |env|
        expect(env.url.path).to eq('/channels')
        [
          200,
          { 'Content-Type': 'application/javascript' },
          file_fixture('front/channels/all.json').to_s
        ]
      end

      expect(subject.all).to be_success
    end
  end
end
