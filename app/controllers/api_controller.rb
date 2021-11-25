# frozen_string_literal: true

class ApiController < ActionController::API
  unless Rails.env.development?
    rescue_from Exception, with: :exception_handler
  end

  before_action :authenticate_api_key

  private

  def authenticate_api_key
    api_key = request.headers['Api-Key']
    return true if api_key ==
                   Rails.application.credentials.dig(:api, :api_key)

    render json: { message: 'Not authorized' }, status: :unauthorized
  end

  def exception_handler(exception)
    case exception
    # You can define your own exception somewhere
    # raise it in the code and catch here
    # when MyCustomException
    #  render json: { message: 'Something goes wrong' }, status: :unprocessable_entity
    when ActionController::UnknownFormat, ActionController::InvalidCrossOriginRequest
      render json: { message: 'Bad request' }, status: :unprocessable_entity
    when ActiveRecord::RecordNotFound, ActionController::RoutingError
      render json: { message: 'Not found' }, status: :not_found
    else
      Rollbar.error(exception)
      render json: { message: 'Internal error' }, status: :internal_server_error
    end
  end
end
