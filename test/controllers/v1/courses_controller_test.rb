require 'test_helper'

module V1
  # Course REST JSON API
  class CoursesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @client = clients(:one)
      @client_headers = { 'x-jwt' => @client.jwt }
      @account = accounts :one
      @account_headers = { 'corse-account' => @account.jwt }
      @course = courses(:one)
      @new_course = Course.new name: 'new course'
      @new_course.client = @account.client
      serializer = ActiveModel::SerializableResource.new(@new_course)
      @course_params = serializer.as_json
      @nonce = @client.jwt({ uid: @account.uid }, @client.secret)
    end

    test 'account should get index of courses' do
      get v1_courses_url, headers: @account_headers
      assert_response :success
      size = @account.client.courses.count
      assert_equal size, JSON.parse(@response.body)['data'].size
    end

    test 'account should create course with client signature' do
      assert_difference('Course.count') do
        @account_headers['Corse-Nonce'] = @nonce
        post v1_courses_url, params: @course_params, headers:  @account_headers
      end

      assert_response 201
      @account.role? :teacher, Course.last
    end

    test 'account should not create course without valid signature' do
      assert_difference('Course.count', 0) do
        post v1_courses_url, params: @course_params, headers:  @account_headers
      end

      assert_response :unauthorized
    end

    test 'account should show course' do
      get v1_course_url(@course), headers:  @account_headers
      assert_response :success
      assert_match @course.name, @response.body
    end

    test 'teacher should update his course' do
      @account.add_role :teacher, @course
      opts = { params: @course_params, headers:  @account_headers }
      patch v1_course_url(@course), opts
      assert_response 200
    end

    test 'client should destroy course' do
      assert_difference('Course.count', -1) do
        delete v1_course_url(@course), headers:  @client_headers
      end

      assert_response 204
    end

    test 'teacher should destroy his course' do
      @account.add_role :teacher, @course
      assert_difference('Course.count', -1) do
        delete v1_course_url(@course), headers:  @account_headers
      end

      assert_response 204
    end

    test 'account should not destroy course' do
      assert_difference('Course.count', 0) do
        delete v1_course_url(@course), headers:  @account_headers
      end

      assert_response :unauthorized
    end
  end
end
