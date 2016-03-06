require 'test_helper'

module V1
  # Course REST JSON API
  class CoursesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @client = clients(:two)
      @account = accounts :one
      @account_headers = { 'corse-account' => @account.jwt }
      @course = courses(:one)
      @new_course = Course.new name: 'new assign'
      @new_course.client = @client
      serializer = ActiveModel::SerializableResource.new(@new_course)
      @course_params = serializer.as_json
    end

    test 'account should get index of his course' do
      get v1_courses_url, headers: @account_headers
      assert_response :success
    end

    test 'account should create course' do
      assert_difference('Course.count') do
        post v1_courses_url, params: @course_params, headers:  @account_headers
      end

      assert_response 201
    end

    test 'account should show his course' do
      get v1_course_url(@course), headers:  @account_headers
      assert_response :success
    end

    test 'account should update his course' do
      opts = { params: @course_params, headers:  @account_headers }
      patch v1_course_url(@course), opts
      assert_response 200
    end

    test 'account should destroy his course' do
      assert_difference('Course.count', -1) do
        delete v1_course_url(@course), headers:  @account_headers
      end

      assert_response 204
    end
  end
end
