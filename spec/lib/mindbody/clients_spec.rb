# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mindbody::Clients, type: :lib do
  let(:subject) { described_class.new }

  describe 'all' do
    xit 'returns all clients' do
      expect(subject.all).to be_success
    end
  end

  describe 'get' do
    xit 'returns a single client' do
      expect(subject.get(1)).to be_success
    end
  end
end
