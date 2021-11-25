class AddZendeskIdToLeads < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :zendesk_id, :string
  end
end
