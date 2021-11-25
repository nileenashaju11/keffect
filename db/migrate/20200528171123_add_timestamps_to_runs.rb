class AddTimestampsToRuns < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :runs, null: true

    Run.update_all(created_at: Time.current, updated_at: Time.current)

    change_column_null :runs, :created_at, false
    change_column_null :runs, :updated_at, false
  end
end
