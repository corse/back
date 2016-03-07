require 'test_helper'

module V1
  # Assignment API TEST
  class AssignmentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @assignment = assignments(:one)
      @new_assignment = Assignment.new title: 'new assign'
      @new_assignment.course = courses :one
      serializer = ActiveModel::SerializableResource.new(@new_assignment)
      @assign_params = serializer.as_json
      @account = accounts :one
      @account_headers = { 'corse-account' => @account.jwt }
    end

    test 'account should get index' do
      get v1_assignments_url, headers:  @account_headers
      assert_response :success
    end

    test 'teacher should create assignment' do
      assert_difference('Assignment.count') do
        opts = { params: @assign_params, headers:  @account_headers }
        post v1_assignments_url, opts
      end

      assert_response 201
    end

    test 'account should show assignment' do
      get v1_assignment_url(@assignment), headers:  @account_headers
      assert_response :success
    end

    test 'teacher should update assignment' do
      opts = { params: @assign_params, headers:  @account_headers }
      patch v1_assignment_url(@assignment), opts
      assert_response 200
    end

    test 'account should not update assignment' do
    end

    test 'account should not destroy assignment' do
    end

    test 'teacher should destroy assignment' do
      assert_difference('Assignment.count', -1) do
        delete v1_assignment_url(@assignment), headers:  @account_headers
      end

      assert_response 204
    end
  end
end
