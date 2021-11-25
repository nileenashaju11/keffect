# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Run, type: :model do
  let(:action) { create(:action) }

  describe 'perform_at' do
    it 'returns normal delay_until if not in blackout hours' do
      travel_to Time.current.noon
      expect(action.perform_at).to eq(action.delay_until)
      travel_back
    end

    it 'respects blackout hours' do
      Setting.blackout_hours_start.update(value: Time.zone.parse('10:00PM'))
      Setting.blackout_hours_end.update(value: Time.zone.parse('5:00AM'))
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('11:00PM'))

      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.tomorrow.day)
      travel_to Time.current.midnight
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('12:00AM'))
      expect(action.perform_at.hour).to eq(5)
      travel_back
      expect(action.perform_at.day).to eq(DateTime.current.day)
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('3:00PM'))
      expect(action.perform_at.hour).to eq(15)
      expect(action.perform_at.day).to eq(DateTime.current.day)
    end

    it 'respects a real example blackout hours' do
      Setting.blackout_hours_start.update(value: Time.zone.parse('12:15AM'))
      Setting.blackout_hours_end.update(value: Time.zone.parse('5:30AM'))
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('11:00PM'))
      expect(action.perform_at.hour).to eq(23)
      expect(action.perform_at.day).to eq(DateTime.current.day)
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('12:00AM'))
      expect(action.perform_at.hour).to eq(0)
      expect(action.perform_at.day).to eq(DateTime.current.day)
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('3:00PM'))
      expect(action.perform_at.hour).to eq(15)
      expect(action.perform_at.day).to eq(DateTime.current.day)
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('3:00AM'))
      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.current.day)
    end

    it 'respects another real example' do
      Setting.blackout_hours_start.update(value: '2020-07-02 00:15:00 +0000')
      Setting.blackout_hours_end.update(value: '2020-07-02 05:30:00 +0000')
      travel_to Time.zone.parse('15:45')
      allow(action).to receive(:delay_until).and_return(720.minutes.from_now)
      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.tomorrow.day)
      travel_back
    end

    it 'respects starting a new run immediately within a blackout period' do
      Setting.blackout_hours_start.update(value: Time.zone.parse('12:15AM'))
      Setting.blackout_hours_end.update(value: Time.zone.parse('5:30AM'))
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('2:56AM'))
      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.current.day)

      travel_to Time.zone.parse('12:56AM')
      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.current.day)
      travel_back
    end

    it 'works properly across multiple days' do
      Setting.blackout_hours_start.update(value: Time.zone.parse('12:15AM'))
      Setting.blackout_hours_end.update(value: Time.zone.parse('5:30AM'))
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('3:00AM'))
      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.current.day)
      allow(action).to receive(:delay_until).and_return(Time.zone.parse('3:00AM') + 1.day)
      expect(action.perform_at.hour).to eq(5)
      expect(action.perform_at.day).to eq(DateTime.current.tomorrow.day)
    end
  end
end
