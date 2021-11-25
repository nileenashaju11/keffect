# frozen_string_literal: true

class ResourceController < ApplicationController
  before_action :authenticate_user!
  before_action :set_object, only: %i[show edit update]

  def index
    @collection = model_class.all
    instance_variable_set("@#{controller_name}", @collection)
  end

  def show; end

  def new
    @object = model_class.new
    instance_variable_set("@#{object_name}", @object)
  end

  def create
    @object = model_class.new(permitted_resource_params)
    instance_variable_set("@#{object_name}", @object)

    if @object.save
      flash[:success] = "Successfully created #{object_name.humanize}"
      redirect_to send("#{object_name}_path", @object)
    else
      flash[:error] = @object.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def edit; end

  def update
    if @object.update(permitted_resource_params)
      flash[:success] = "Successfully updated #{object_name.humanize}"
      redirect_to send("edit_#{object_name}_path", @object)
    else
      flash[:error] = @object.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  ##
  # Destroys object from database
  #
  def destroy
    @object = model_class.find_by(id: params[:id])
    @object&.destroy
    flash[:success] = "Successfully removed #{object_name.humanize}"
    redirect_to send("#{controller_name}_path")
  end

  private

  def set_object
    @object = model_class.find(params[:id])
    instance_variable_set("@#{object_name}", @object)
  end

  def model_class
    controller_name.classify.constantize
  end

  def object_name
    controller_name.singularize
  end
end
