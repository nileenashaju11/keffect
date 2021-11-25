# frozen_string_literal: true

# Simple CRUD for Flow
class FlowsController < ResourceController
  def update
    if @object.update(permitted_resource_params)
      flash[:success] = "Successfully updated #{object_name.humanize}"
      redirect_to send("#{object_name}_path", @object)
    else
      flash[:error] = @object.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  private

  def permitted_resource_params
    params.require(:flow).permit(:name, :zendesk_stage_id)
  end
end
