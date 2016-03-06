module V1
  # Account REST JSON API
  class AccountsController < ApplicationController
    before_action :set_account, only: [:show, :update, :destroy]

    # GET /v1/accounts
    def index
      @accounts = if current_client
                    current_client.accounts
                  elsif current_account
                    current_account.client.accounts
                  else
                    Account.none
                  end

      render json: @accounts
    end

    # GET /v1/accounts/1
    def show
      render json: @account
    end

    # POST /v1/accounts
    def create
      @account = Account.new(jsonapi_params)

      if @account.save
        render json: @account, status: :created
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/accounts/1
    def update
      if @account.update(account_params)
        render json: @account
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/accounts/1
    def destroy
      @account.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.fetch(:data, {}).fetch(:attributes, {})
            .permit(:client_id, :uid)
    end

    def jsonapi_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end
  end
end
