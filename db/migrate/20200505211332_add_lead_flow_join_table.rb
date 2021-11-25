class AddLeadFlowJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_join_table :leads, :flows do |t|
      t.index :lead_id
      t.index :flow_id

      t.index [:lead_id, :flow_id]
    end
  end
end
