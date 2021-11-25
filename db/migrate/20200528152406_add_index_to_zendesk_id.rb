class AddIndexToZendeskId < ActiveRecord::Migration[6.0]
  def change
    add_index :leads, :zendesk_id
  end
end
