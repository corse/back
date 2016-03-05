# Base APP class
class ApplicationController < ActionController::API
  include Pundit
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::StatementInvalid, with: :record_statement_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  private

  def record_not_found
    render json: { errors: [{ id: 'RecordNotFound' }] }, status: :not_found
  end

  def record_statement_found
    render json: { errors: [{ id: 'StatementInvalid' }] },
           status: :unprocessable_entity
  end

  def not_authorized(e)
    render json: { errors: [{ id: 'NotAuthorized' }] }, status: :unauthorized
  end

  def render_error(name, status)
    render json: { errors: [{ id: name }] }, status: status
  end

  def current_client
    @current_client ||= Client.find_by_jwt request.headers['X-Jwt']
  end
end
