class CreateAction < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.belongs_to :flow, index: true
      t.integer :order, default: 1
      t.text :text

      t.timestamps
    end
  end
end
