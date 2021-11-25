# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionServices::FormatService, type: :service do
  let(:run) { create(:run) }
  let(:action) { run.actions.first }
  let(:content) { action.content.body.to_s }
  let(:subject) { described_class.new(run, content) }

  before(:each) do
    ActiveSupport.run_load_hooks :action_text_content, ActionText::Content
  end

  it 'returns a string' do
    expect(subject.execute).to be_a(String)
  end

  describe '#substitite_first_name' do
    before do
      action.update(content: '[First Name]')
    end

    it 'substitutes First Name' do
      expect(subject.execute).not_to include('[First Name]')
      expect(subject.execute).to include(run.lead.first_name)
    end
  end

  describe '#substitute_acuity_appointment' do
    before do
      action.update(content: '[Acuity Appointment]')
    end

    it 'returns a default string if no appointment is found' do
      expect(subject.execute).not_to include('[Acuity Appointment]')
      expect(subject.execute).to include('soon')
    end

    it 'substitutes Acuity Appointment' do
      appointment = create(:appointment, email: run.lead.email)
      expect(subject.execute).not_to include('[Acuity Appointment]')
      appointment_time = appointment.starts_at.strftime('%A at%l:%M%P')
      expect(subject.execute).to include(appointment_time)
    end
  end
end
