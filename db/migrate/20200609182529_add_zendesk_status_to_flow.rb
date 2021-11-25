class AddZendeskStatusToFlow < ActiveRecord::Migration[6.0]
  def change
    create_table :zendesk_statuses do |t|
      t.string :status, null: false, index: { unique: true }

      t.timestamps
    end

    add_reference :flows, :zendesk_status
  end
end
