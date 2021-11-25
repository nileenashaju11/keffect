class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.string :email, index: true
      t.string :acuity_appointment_id, null: false, index: true
      t.string :mindbody_class_id, null: false, index: true

      t.timestamps
    end

    add_index :appointments, [:acuity_appointment_id, :mindbody_class_id], unique: true, name: 'acuity_mindbody_index'
  end
end
