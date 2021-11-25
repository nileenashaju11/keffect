class ExpandActions < ActiveRecord::Migration[6.0]
  def change
    add_column :actions, :type, :string
    add_column :actions, :delay, :integer
  end
end
