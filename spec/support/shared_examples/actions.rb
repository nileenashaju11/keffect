# frozen_string_literal: true

RSpec.shared_examples_for 'an Action' do
  let(:action) { described_class.new }

  it_behaves_like 'Historical'

  describe 'callbacks' do
    let(:action) { build(:action) }

    context 'before_create' do
      it 'calls set_order' do
        expect(action).to receive(:set_order)
        action.save
      end
    end
  end

  describe 'execute' do
    let(:action) { create(:action) }

    it 'returns an OpenStruct' do
      expect(action.execute).to be_kind_of(OpenStruct)
      expect(action.execute.success?).to eq(true)
    end
  end
end
