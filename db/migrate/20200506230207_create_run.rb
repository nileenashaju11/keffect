class CreateRun < ActiveRecord::Migration[6.0]
  def change
    rename_table :flows_leads, :runs
  end
end
