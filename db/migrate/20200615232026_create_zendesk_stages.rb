class CreateZendeskStages < ActiveRecord::Migration[6.0]
  def change
    create_table :zendesk_stages do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :position, null: false
      t.string :zendesk_id, null: false, index: { unique: true }

      t.timestamps
    end

    add_reference :flows, :zendesk_stage
  end
end
