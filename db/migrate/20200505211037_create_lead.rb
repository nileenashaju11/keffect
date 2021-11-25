class CreateLead < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end
end
