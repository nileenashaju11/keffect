class AddScheduledJobIdToRun < ActiveRecord::Migration[6.0]
  def change
    add_column :runs, :scheduled_job_id, :string
  end
end
