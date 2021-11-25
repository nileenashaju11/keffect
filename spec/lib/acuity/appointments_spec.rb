# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Acuity::Appointments, type: :lib do
  let(:subject) { described_class.new }

  describe 'all' do
    # Skipping because their current acuity plan is not high enough to use the
    # custom api
    xit 'returns all appointments' do
      expect(subject.all).to be_success
    end
  end
end
