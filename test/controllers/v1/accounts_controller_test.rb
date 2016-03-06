require 'test_helper'

module V1
  # Account REST JSON API
  class AccountsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @account = accounts(:one)
      @account_2 = accounts(:two)
      @client = clients(:one)
      @client_headers = { 'x-jwt' => @client.jwt }
      @new_account = Account.new uid: 12
      @new_account.client = @client
      serializer = ActiveModel::SerializableResource.new(@new_account)
      @account_params = serializer.as_json
      @account_headers = { 'corse-account' => @account.jwt }
    end

    test 'client should get his user accounts index' do
      get v1_accounts_url, headers: @client_headers
      assert_response :success
    end

    test 'client\'s user should get client\' user index' do
      get v1_accounts_url, headers: @account_headers
      assert_response :success
    end

    test 'client should create account' do
      assert_difference('Account.count') do
        post v1_accounts_url, params: @account_params, headers: @client_headers
      end

      assert_response 201
    end

    test 'guest should not create account' do
      assert_difference('Account.count', 0) do
        post v1_accounts_url, params: @account_params
      end

      assert_response :unauthorized
    end

    test 'client\' user account should be created automatically upon visit' do
      assert_difference('Account.count') do
        headers = { 'corse-account' => @new_account.jwt }
        get v1_accounts_url, headers: headers
      end

      assert_response :success
    end

    test 'client should show account' do
      get v1_account_url(@account), headers: @client_headers
      assert_response :success
    end

    test 'client\'s user should show himself' do
      get v1_account_url(@account), headers: @account_headers
      assert_response :success
    end

    test 'client should update his user account' do
      params = { data: { attributes: { uid: 32 } } }
      patch v1_account_url(@account), params: params, headers: @client_headers
      assert_response 200
      assert_match(/32/, @response.body)
    end

    test 'client\'s user should update himself' do
      params = { data: { attributes: { uid: 32 } } }
      patch v1_account_url(@account), params: params, headers: @account_headers
      assert_response 200
      assert_match(/32/, @response.body)
    end

    test 'guest should not update user account' do
      params = { data: { attributes: { uid: 32 } } }
      patch v1_account_url(@account), params: params
      assert_response :unauthorized
      assert_no_match(/32/, @response.body)
    end

    test 'client should destroy account' do
      assert_difference('Account.count', -1) do
        delete v1_account_url(@account), headers: @client_headers
      end

      assert_response 204
    end

    test 'client\' user should not destroy account' do
      assert_difference('Account.count', 0) do
        delete v1_account_url(@account), headers: @account_headers
      end

      assert_response :unauthorized
    end
  end
end
