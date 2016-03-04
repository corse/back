require 'test_helper'

module V1
  # Profile REST JSON API
  class ProfilesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @v1_profile = profiles(:one)
      @client = clients(:one)
    end

    test 'should get index' do
      get v1_profiles_url
      assert_response :success
    end

    test 'should create v1_profile' do
      assert_difference('Profile.count') do
        params = { data: { attributes: {} } }
        params[:data][:attributes][:client_id] = @client.id
        params[:data][:attributes][:user_id] = 32
        post v1_profiles_url, params: params
      end

      assert_response 201
    end

    test 'should show v1_profile' do
      get v1_profile_url(@v1_profile)
      assert_response :success
    end

    test 'should update v1_profile' do
      patch v1_profile_url(@v1_profile), params: { v1_profile: {  } }
      assert_response 200
    end

    test 'should destroy v1_profile' do
      assert_difference('Profile.count', -1) do
        delete v1_profile_url(@v1_profile)
      end

      assert_response 204
    end
  end
end
