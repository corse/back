module V1
  # Solution REST JSON API
  class SolutionsController < ApplicationController
    prepend_before_action :set_resource, only: [:show, :update, :destroy]
    prepend_before_action :new_resource, only: [:create]
    before_action :auth_resource, except: [:index]

    # GET /v1/solutions
    def index
      @solutions = Solution.all

      render json: @solutions
    end

    # GET /v1/solutions/1
    def show
      render json: @solution
    end

    # POST /v1/solutions
    def create
      @solution = Solution.new(jsonapi_params)

      if @solution.save
        render json: @solution, status: :created
      else
        render json: @solution.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/solutions/1
    def update
      if @solution.update(solution_params)
        render json: @solution
      else
        render json: @solution.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/solutions/1
    def destroy
      @solution.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @solution = Solution.find(params[:id])
    end

    def new_resource
      @solution = Solution.new(solution_params)
    end

    def auth_resource
      authorize @solution
    end

    def pundit_user
      current_account
    end

    # Only allow a trusted parameter "white list" through.
    def solution_params
      params.fetch(:data, {}).fetch(:attributes, {})
            .permit(:content)
    end

    def jsonapi_params
      ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    end
  end
end
