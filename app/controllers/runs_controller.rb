# frozen_string_literal: true

# Handles CRUD for Runs
class RunsController < ResourceController
  before_action :set_flow, only: %i[index]
  before_action :set_run, only: %i[cancel resume]

  def index
    @runs = @flow.present? ? @flow.runs : Run.all
  end

  def new
    @run = Run.new(flow_id: params[:flow_id], lead_id: params[:lead_id])
  end

  def resume
    @run.queue_next_action
    flash[:success] = 'Run successfully resumed.'
    redirect_back(fallback_location: flows_path)
  end

  def cancel
    if @run.cancel_scheduled_action
      flash[:success] = 'Run successfully cancelled.'
    else
      flash[:error] = 'Run was not canceled.'
    end
    redirect_back(fallback_location: flows_path)
  end

  private

  def set_flow
    @flow = Flow.find_by(id: params[:flow_id])
  end

  def set_run
    @run = Run.find(params[:id])
  end

  def permitted_resource_params
    params.require(:run).permit(:flow_id, :lead_id)
  end
end
