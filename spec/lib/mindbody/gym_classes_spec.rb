# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mindbody::GymClasses, type: :lib do
  let(:subject) { described_class.new }

  describe 'all' do
    xit 'returns all classes' do
      expect(subject.all).to be_success
    end
  end

  describe 'schedules' do
    xit 'returns schedules' do
      expect(subject.schedules).to be_success
    end
  end

  describe 'add_client_to_class' do
    xit 'adds client to class' do
      expect(subject.add_client_to_class('100000807', 12_900, true, true, true)).to be_success
    end
  end
end
