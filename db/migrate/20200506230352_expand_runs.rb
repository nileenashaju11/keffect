class ExpandRuns < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :status, :string
  end
end
