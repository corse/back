module V1
  # Assignment REST JSON API
  class AssignmentsController < ApplicationController
    prepend_before_action :set_resource, only: [:show, :update, :destroy]
    prepend_before_action :new_resource, only: [:create]
    before_action :auth_resource, except: [:index]

    # GET /v1/assignments
    def index
      @assignments = Assignment.all

      render json: @assignments
    end

    # GET /v1/assignments/1
    def show
      render json: @assignment
    end

    # POST /v1/assignments
    def create
      if @assignment.save
        render json: @assignment, status: :created
      else
        render json: @assignment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/assignments/1
    def update
      if @assignment.update(assignment_params)
        render json: @assignment
      else
        render json: @assignment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/assignments/1
    def destroy
      @assignment.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @assignment = Assignment.find(params[:id])
    end

    def new_resource
      @assignment = Assignment.new(jsonapi_params)
    end

    def auth_resource
      authorize @assignment
    end

    def pundit_user
      current_account
    end

    # Only allow a trusted parameter "white list" through.
    def assignment_params
      params.fetch(:data, {}).fetch(:attributes, {})
            .permit(:title)
    end
  end
end
