require 'test_helper'

module V1
  # Account REST JSON API
  class AccountsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @account = accounts(:one)
      @client = clients(:one)
      @client_headers = { 'x-jwt' => @client.jwt }
      @new_account = Account.new uid: 12
      @new_account.client = @client
      serializer = ActiveModel::SerializableResource.new(@new_account)
      @account_params = serializer.as_json
    end

    test 'client should get his user accounts' do
      get v1_accounts_url, headers: @client_headers
      assert_response :success
    end

    test 'should create account' do
      assert_difference('Account.count') do
        post v1_accounts_url, params: @account_params
      end

      assert_response 201
    end

    test 'should show account' do
      get v1_account_url(@account)
      assert_response :success
    end

    test 'should update account' do
      params = { data: { attributes: {} } }
      patch v1_account_url(@account), params: params
      assert_response 200
    end

    test 'should destroy account' do
      assert_difference('Account.count', -1) do
        delete v1_account_url(@account)
      end

      assert_response 204
    end
  end
end
