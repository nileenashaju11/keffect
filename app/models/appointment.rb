# frozen_string_literal: true

class Appointment < ApplicationRecord
  scope :upcoming, -> { where(starts_at: Time.current..) }

  def acuity
    acuity = Acuity::Appointments.new
    acuity.get(acuity_appointment_id).body
  end

  def mindbody_class
    mindbody = Mindbody::GymClasses.new
    mindbody.get(mindbody_class_id)
  end
end
