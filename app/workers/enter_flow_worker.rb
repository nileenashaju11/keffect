# frozen_string_literal: true

##
# Finds a Lead and queues up a new Run for any Flow they are qualified for
#
class EnterFlowWorker < ApplicationWorker
  def perform(lead_id)
    if ActiveModel::Type::Boolean.new.cast(Setting.automatically_start_new_runs_enabled.value)
      lead = Lead.find(lead_id)
      zendesk_stage = lead.zendesk_stage
      if zendesk_stage.nil?
        # If there is no zendesk association just put them in the first Flow
        lead.enter_flow(Flow.first)
      else
        # For A/B testing add the user to a random flow of the correct status
        flow = Flow.where(zendesk_stage: lead.zendesk_stage).sample
        lead.enter_flow(flow)
      end
    else
      Rails.logger.warn('[ENTER FLOW WORKER] Disabled via admin.')
    end
  end
end
