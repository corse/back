module V1
  # Client REST JSON API
  class ClientsController < ApplicationController
    before_action :set_resource, only: [:show, :update, :destroy]

    # GET /v1/clients
    def index
      @clients = Client.all

      render json: @clients
    end

    # GET /v1/clients/1
    def show
      render json: @client
    end

    # POST /v1/clients
    def create
      @client = Client.new(jsonapi_params)
      authorize @client

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
    def set_resource
      @client = Client.find(params[:id])
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
