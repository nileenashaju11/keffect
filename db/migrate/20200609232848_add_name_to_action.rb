class AddNameToAction < ActiveRecord::Migration[6.0]
  def change
    add_column :actions, :name, :string
  end
end
