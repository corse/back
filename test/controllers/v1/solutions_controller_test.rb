require 'test_helper'

module V1
  # Solution API
  class SolutionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @solution = solutions(:one)
      @client = clients(:two)
      @account = accounts :one
      @account_headers = { 'corse-account' => @account.jwt }
      @solution = solutions(:one)
      @new_solution = Solution.new content: 'answer'
      @new_solution.assignment = assignments :one
      @new_solution.account = @account
      serializer = ActiveModel::SerializableResource.new(@new_solution)
      @solution_params = serializer.as_json
    end

    test 'teacher should get index' do
      @account.add_role :teacher, @course
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

    test 'account should show his solution' do
      get v1_solution_url(@solution), headers: @account_headers
      assert_response :success
    end

    test 'account should update his solution' do
      opts = { params: @solution_params, headers: @account_headers }
      patch v1_solution_url(@solution), opts
      assert_response 200
    end

    test 'account should not update his solution after submittion' do
      @solution.update submit_at: Time.zone.now
      opts = { params: @solution_params, headers: @account_headers }
      patch v1_solution_url(@solution), opts
      assert_response :unauthorized
    end

    test 'account should not destroy solution after submittion' do
      @solution.update submit_at: Time.zone.now
      assert_difference('Solution.count', 0) do
        delete v1_solution_url(@solution), headers: @account_headers
      end

      assert_response :unauthorized
    end

    test 'account should destroy his solution before submittion' do
    end
  end
end
