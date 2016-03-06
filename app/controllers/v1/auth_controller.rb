module V1
  # Authentication API
  class AuthController < ApplicationController
    def login
      @client = Client.find_by email: params[:email]
      if ! @client || ! @client.authenticate(params.require(:password))
        render json: { errors: [{ id: 'authFailed' }] }, status: :unauthorized
      else
        render json: @client, token: true
      end
    end

    def signup
      @client = Client.new client_params
      if @client.save
        render json: @client
        ClientsMailer
          .confirm_email(@client, params[:redirect_to])
          .deliver_later
      else
        render json: { errors: @client.errors }, status: :unauthorized
      end
    end

    def request_reset
      @client = Client.find_by email: params[:email]
      return head 404 unless @client
      ClientsMailer
        .forgot_password(@client, params[:redirect_to])
        .deliver_later
      render json: { meta: { status: 'sent' } }
    end

    def reset
      @client = Client.find_by_pw_reset_jwt params[:reset_password_token]
      if ! @client
        render json: { errors: [{ id: 'invalidToken' }] },
               status: :unauthorized
      elsif ! @client.valid?
        render json: { errors: [{ id: 'clientNotConfirmed' }] },
               status: :unauthorized
      elsif @client.reset_password! params[:password]
        render json: @client, token: true
      else
        render json: { errors: [{ id: 'clientUpdateFailed' }] },
               status: :unprocessable_entity
      end
    end

    def request_confirm
      @client = Client.find_by email: params[:email]
      if ! @client
        render json: { errors: [{ id: 'clientNotFound' }] }, status: :not_found
      elsif @client.confirmed?
        render json: { errors: [{ id: 'clientAlreadyConfirmed' }] },
               status: :locked
      else
        ClientsMailer.confirm_email(@client, params[:redirect_to]).deliver_later
        render json: { meta: { status: 'sent' } }
      end
    end

    def confirm
      @client = Client.find_by_confirmation_jwt params[:token]
      if ! @client
        render json: { errors: [{ id: 'clientNotFound' }] }, status: :not_found
      elsif @client.confirm!(Client.decode_jwt(params[:token])[0]['email'])
        render json: @client, token: true
      else
        render json: { errors: [{ id: 'confirmationExpired' }] },
               status: :gone
      end
    end

    def signin_client_account
      client = Client.find_by cid: params[:cid]
      return render_error('authFailed', :unauthorized) unless client
      jwt = client.exchange_jwt_with(params[:token])
      render json: { token: jwt }, token: true
    end

    private

    def client_params
      params.permit(:email, :password, :name)
    end
  end
end
