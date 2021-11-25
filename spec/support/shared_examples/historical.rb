# frozen_string_literal: true

RSpec.shared_examples_for 'Historical' do
  let(:subject) { described_class.new }

  it 'has_many histories' do
    expect(subject).to respond_to(:histories)
  end

  describe 'record_history' do
    it 'queues up a HistoryWorker' do
      expect { subject.record_history('test') }.to(
        change(HistoryWorker.jobs, :size).by(1)
      )
    end
  end
end
