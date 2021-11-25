# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistoryWorker, type: :worker do
  describe 'perform' do
    it 'runs successfully for all historical classes' do
      historical_classes = [
        'Action',
        'Email',
        'Flow',
        'Lead',
        'Run',
        'SMS',
        'Voicemail'
      ]
      worker = described_class.new
      historical_classes.each do |historical_class|
        expect { worker.perform(historical_class, 1, 'test') }.not_to raise_error
      end
    end
  end
end
