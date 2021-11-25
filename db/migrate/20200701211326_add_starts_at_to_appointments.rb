class AddStartsAtToAppointments < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :starts_at, :datetime
  end
end
