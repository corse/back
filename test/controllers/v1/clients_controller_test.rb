require 'test_helper'

module V1
  # Client REST JSON API
  class ClientsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @admin = clients(:one)
      @admin.add_role :admin
      @admin_headers = { 'x-jwt' => @admin.jwt }
      @client = clients(:two)
      @client_headers = { 'x-jwt' => @client.jwt }
    end

    test 'admin should get index' do
      @admin.add_role :admin
      assert @admin.role?(:admin)
      get v1_clients_url, headers: @admin_headers
      assert_response :success
    end

    test 'admin should create client' do
      assert_difference('Client.count') do
        params = { data: { attributes: {} } }
        params[:data][:attributes][:email] = 'test1@sd.c'
        params[:data][:attributes][:password] = 'test'
        params[:data][:attributes][:name] = 'test'
        post v1_clients_url, params: params, headers: @admin_headers
      end

      assert_response 201
    end

    test 'admin should show client' do
      get v1_client_url(@admin), headers: @admin_headers
      assert_response :success
    end

    test 'admin should update client' do
      params = { data: { attributes: { name: 'whatas' } } }
      patch v1_client_url(@client), params: params, headers: @admin_headers
      assert_response :success
    end

    test 'admin should not destroy client' do
      assert_difference('Client.count', 0) do
        delete v1_client_url(@client), headers: @admin_headers
      end

      assert_response :unauthorized
    end

    test 'client should see iteself' do
      get v1_client_url(@client), headers: @client_headers
      assert_response :success
    end

    test 'client should not see others' do
      get v1_client_url(@admin), headers: @client_headers
      assert_response :unauthorized
    end

    test 'client should update iteself' do
      params = { data: { attributes: { name: 'whatas' } } }
      patch v1_client_url(@client), params: params, headers: @client_headers
      assert_response :success
    end

    test 'client should not update others' do
      params = { data: { attributes: { name: 'whatas' } } }
      patch v1_client_url(@admin), params: params, headers: @client_headers
      assert_response :unauthorized
    end
  end
end
