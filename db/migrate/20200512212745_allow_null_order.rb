class AllowNullOrder < ActiveRecord::Migration[6.0]
  def change
    change_column :actions, :order, :integer, null: true, default: nil
  end
end
