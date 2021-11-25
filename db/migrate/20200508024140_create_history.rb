class CreateHistory < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.text :text, null: false
      t.references :subject, polymorphic: true
      t.timestamps
    end
  end
end
