# frozen_string_literal: true

class SettingsController < ResourceController
  before_action :ensure_settings_are_there, only: %i[index]

  def index
    super
  end

  private

  def permitted_resource_params
    permitted_params = params.require(:setting).permit(:value)
    # If there are more than one value we need to consolidate
    if permitted_params.keys.size > 1
      permitted_params[:value] = Time.strptime(
        "#{permitted_params['value(4i)']}:#{permitted_params['value(5i)']}",
        '%k:%M'
      )
      # Remove old params
      permitted_params.delete_if { |k, _v| k.include?('(') }
    end
    permitted_params
  end

  def ensure_settings_are_there
    Setting.blackout_hours_start
    Setting.blackout_hours_end
    Setting.zendesk_sync_enabled
    Setting.acuity_to_mindbody_sync_enabled
    Setting.mindbody_to_acuity_sync_enabled
    Setting.automatically_start_new_runs_enabled
  end
end
