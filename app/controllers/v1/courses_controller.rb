module V1
  # Course REST JSON API
  class CoursesController < ApplicationController
    prepend_before_action :set_resource, only: [:show, :update, :destroy]
    prepend_before_action :new_resource, only: [:create]
    before_action :auth_resource, except: [:index]

    # GET /v1/courses
    def index
      @courses = Course.all

      render json: @courses
    end

    # GET /v1/courses/1
    def show
      render json: @course
    end

    # POST /v1/courses
    def create
      if @course.save
        render json: @course, status: :created
      else
        render json: @course.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /v1/courses/1
    def update
      if @course.update(course_params)
        render json: @course
      else
        render json: @course.errors, status: :unprocessable_entity
      end
    end

    # DELETE /v1/courses/1
    def destroy
      @course.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @course = Course.find(params[:id])
    end

    def new_resource
      @course = Course.new(jsonapi_params)
    end

    def auth_resource
      authorize @course
    end

    def pundit_user
      current_account
    end

    # Only allow a trusted parameter "white list" through.
    def course_params
      params.fetch(:data, {}).fetch(:attributes, {})
            .permit(:name)
    end
  end
end
