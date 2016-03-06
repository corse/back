require 'test_helper'

module V1
  # Solution API
  class SolutionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @solution = solutions(:one)
      @account = accounts :one
      @account_headers = { 'corse-account' => @account.jwt }
      @new_solution = Solution.new content: 'answer'
      @new_solution.assignment = assignments :two
      @new_solution.account = @account
      serializer = ActiveModel::SerializableResource.new(@new_solution)
      @solution_params = serializer.as_json
    end

    test 'account should get index' do
      get v1_solutions_url, headers: @account_headers
      assert_response :success
    end

    test 'account should create solution' do
      assert_difference('Solution.count') do
        opts = { params: @solution_params, headers: @account_headers }
        post v1_solutions_url, opts
      end

      assert_response 201
    end

    test 'account should show solution' do
      get v1_solution_url(@solution), headers: @account_headers
      assert_response :success
    end

    test 'account should update solution' do
      opts = { params: @solution_params, headers: @account_headers }
      patch v1_solution_url(@solution), opts
      assert_response 200
    end

    test 'account should destroy solution' do
      assert_difference('Solution.count', -1) do
        delete v1_solution_url(@solution), headers: @account_headers
      end

      assert_response 204
    end
  end
end
