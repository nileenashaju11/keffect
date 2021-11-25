class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :key, null: false, index: true
      t.string :value
      t.timestamps
    end
  end
end
