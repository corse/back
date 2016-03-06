# Base APP class
class ApplicationController < ActionController::API
  include Pundit
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::StatementInvalid, with: :record_statement_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from JWT::DecodeError, with: :auth_failed

  private

  def record_not_found
    render json: { errors: [{ id: 'RecordNotFound' }] }, status: :not_found
  end

  def record_statement_found
    render json: { errors: [{ id: 'StatementInvalid' }] },
           status: :unprocessable_entity
  end

  def not_authorized(e)
    body = { errors: [{ id: 'NotAuthorized', body: e.inspect }] }
    render json: body, status: :unauthorized
  end

  def auth_failed
    render json: { errors: [{ id: 'authFailed' }] }, status: :unauthorized
  end

  def render_error(name, status)
    render json: { errors: [{ id: name }] }, status: status
  end

  def current_client
    @current_client ||= Client.find_by_jwt request.headers['X-Jwt']
  end

  def current_account
    token = request.headers['Corse-Account']
    @current_account ||= Account.find_or_create_by_jwt token
  end

  def jsonapi_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
