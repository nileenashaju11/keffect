# frozen_string_literal: true

# Handles CRUD for Actions
class ActionsController < ResourceController
  before_action :set_flow, only: %i[index new create]

  def index
    @actions = @flow.actions
  end

  def new
    order = @flow.actions.maximum(:order) ? @flow.actions.maximum(:order) + 1 : 1
    @action = Action.new(flow: @flow, order: order )
  end

  def create
    @action = Action.new(permitted_resource_params)
    @action.flow = @flow
    if @action.save
      @action.record_history('Created.')
      flash[:success] = 'Action successfully created.'
      redirect_to @flow
    else
      flash[:error] = @action.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    class_type = permitted_resource_params[:type]
    # Classify removes the trailing 's' assuming it's a plural. In our case
    # we cant to keep that for SMS
    class_type = class_type.classify unless class_type == 'SMS'
    klass = class_type.safe_constantize
    @action = @action.becomes!(klass)
    if @action.update(permitted_resource_params)
      @action.record_history("Updated. #{@action.display_changes}")
      flash[:success] = 'Action successfully updated.'
      redirect_to @action.flow
    else
      flash[:error] = @action.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @action = Action.find_by(id: params[:id])
    @action&.destroy
    flash[:success] = 'Action Successfully removed.'
    redirect_back(fallback_location: flows_path)
  end

  ##
  # Sets the order variable and then reorders all other actions as needed
  #
  def reorder
    set_action
    flow = @action.flow
    order = params[:order].to_i
    order = flow.actions.maximum(:order) if order > flow.actions.maximum(:order)
    # If moving from the front of the queue to the second element we want to
    # move the second element to the first. This boolean checks if we need to
    # decrease or increase the other elements to keep the proper queue
    decrease_duplicates = @action.order < order

    @action.update(order: order)

    # Fix other items in the flow to have proper order
    correct_order = @action
    duplicates = @action.flow.actions.where(order: order)
    while duplicates.size > 1 && (order < 1 || order <= @action.flow.actions.size)
      if decrease_duplicates
        order -= 1
      else
        order += 1
      end
      correct_order = duplicates.where.not(id: correct_order.id).first
      correct_order.update(order: order)
      duplicates = @action.flow.actions.where(order: order)
    end
    flash[:success] = 'Successfully reordered actions'
    render json: { success: true }
  end

  private

  def set_flow
    @flow = Flow.find(params[:flow_id])
  end

  def set_action
    @action = Action.find(params[:id])
  end

  def permitted_resource_params
    params.require(:action_params).permit(
      :audio_file,
      :content,
      :delay,
      :name,
      :order,
      :subject,
      :type,
    )
  end
end
