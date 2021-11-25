class AddDefaultDelay < ActiveRecord::Migration[6.0]
  def change
    change_column :actions, :delay, :integer, default: 0
  end
end
