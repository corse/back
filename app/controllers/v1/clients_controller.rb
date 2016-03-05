module V1
  # Client REST JSON API
  class ClientsController < ApplicationController
    prepend_before_action :set_client, only: [:show, :update, :destroy]
    prepend_before_action :new_client, only: [:create]
    before_action :auth_client, except: [:index]

    # GET /v1/clients
    def index
      raise Pundit::NotAuthorizedError unless current_client.try :role?, :admin

      @clients = Client.all

      render json: @clients
    end

    # GET /v1/clients/1
    def show
      render json: @client
    end

    # POST /v1/clients
    def create
      if @client.save
        render json: @client, status: :created
      else
        render json: @client.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/clients/1
    def update
      if @client.update(client_params)
        render json: @client
      else
        render json: @client.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/clients/1
    def destroy
      @client.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    def new_client
      @client = Client.new(client_params)
    end

    def auth_client
      authorize @client
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.fetch(:data, {}).fetch(:attributes, {})
            .permit(:email, :name, :password)
    end

    def pundit_user
      current_client
    end
  end
end
