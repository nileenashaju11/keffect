class AddZendeskStageToLeads < ActiveRecord::Migration[6.0]
  def up
    add_column :leads, :zendesk_stage_id, :integer, index: true

    Lead.all.find_each do |lead|
      begin
        zendesk = lead.zendesk
        next if zendesk.nil?

        zendesk_stage_id = zendesk.stage_id
        Lead.update(zendesk_stage: ZendeskStage.find_by(zendesk_id: zendesk_stage_id))
      rescue BaseCRM::ErrorsCollection => e
        Rails.logger.warn("[LEAD MIGRATION] #{lead.id} failed to have correct zendesk_id")
        lead.update(zendesk_id: nil)
      end
    end
  end

  def down
    remove_column :leads, :zendesk_stage_id
  end
end
