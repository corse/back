# Base APP class
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::StatementInvalid, with: :record_statement_found

  private

  def record_not_found(e)
    render json: e, status: :not_found
  end

  def record_statement_found(e)
    render json: e, status: :unprocessable_entity
  end

  def current_client
    @current_client ||= Client.find_by_jwt request.headers['X-Jwt']
  end

  def authenticate
    unless current_client
      render json: { errors: [{ id: 'unauthorized' }] }, status: :unauthorized
    end
  end
end
