require 'test_helper'

module V1
  # Client REST JSON API
  class ClientsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @v1_client = clients(:one)
    end

    test 'should get index' do
      get v1_clients_url
      assert_response :success
    end

    test 'should create v1_client' do
      assert_difference('Client.count') do
        params = { data: { attributes: {} } }
        params[:data][:attributes][:email] = 'test1@sd.c'
        params[:data][:attributes][:password] = 'test'
        params[:data][:attributes][:name] = 'test'
        post v1_clients_url, params: params
      end

      assert_response 201
    end

    test 'should show v1_client' do
      get v1_client_url(@v1_client)
      assert_response :success
    end

    test 'should update v1_client' do
      params = { data: { attributes: { name: 'whatas' } } }
      patch v1_client_url(@v1_client), params: params
      assert_response :success
    end

    test 'should destroy v1_client' do
      assert_difference('Client.count', -1) do
        delete v1_client_url(@v1_client)
      end

      assert_response 204
    end
  end
end
