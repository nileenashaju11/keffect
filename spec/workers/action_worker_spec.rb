# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionWorker, type: :worker do
  describe 'perform' do
    let(:run) { create(:run) }

    it 'runs successfully' do
      worker = described_class.new
      expect { worker.perform(run.id) }.not_to raise_error
    end

    it 'fails if run is not found' do
      worker = described_class.new
      expect { worker.perform(0) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
