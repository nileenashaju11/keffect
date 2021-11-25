class AddActionPointersToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :id, :primary_key
    add_column :runs, :previous_action_id, :bigint
    add_column :runs, :next_action_id, :bigint

    add_index :runs, :previous_action_id
    add_index :runs, :next_action_id
  end
end
