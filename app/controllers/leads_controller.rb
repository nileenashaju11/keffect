# frozen_string_literal: true

class LeadsController < ResourceController
  def bulk_destroy
    lead_ids = params.permit(deleted: []).dig(:deleted)
    Lead.destroy(lead_ids) if lead_ids.present?
    flash[:success] = 'Successfully deleted leads'
    redirect_to leads_path
  end

  private

  def permitted_resource_params
    params.require(:lead).permit(:name, :phone_number, :email)
  end
end
