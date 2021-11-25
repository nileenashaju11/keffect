class AddUniqueIndexToSettings < ActiveRecord::Migration[6.0]
  def change
    remove_index :settings, :key
    add_index :settings, :key, unique: true
  end
end
