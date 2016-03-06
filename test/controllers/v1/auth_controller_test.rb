require 'test_helper'

module V1
  # Authenticate API
  class AuthControllerTest < ActionDispatch::IntegrationTest
    include ActiveJob::TestHelper
    setup do
      @client = clients(:one)
      @client_2 = clients(:two)
      @redirect_url = 'http://localhost'
    end

    def switch_email(client_1, client_2)
      email_1 = client_1.email
      email_2 = client_2.email
      client_1.update email: 'tempemail.address'
      assert client_2.update email: email_1
      assert client_1.update email: email_2
    end

    test 'client should login with email and password' do
      assert @client.confirm!
      params = { email: @client.email, password: 'password' }
      post v1_auth_login_url, params: params
      assert_response :success
      token = JSON.parse(@response.body)['data']['attributes']['token']
      assert Client.decode_jwt(token)
    end

    test 'client should signup with email name and password ' do
      params = { email: 'new@email.com', password: 'password', name: 'test' }
      post v1_auth_signup_url, params: params
      assert_response :success
      assert_match(/attributes/, @response.body)
      assert_match(/token/, @response.body)
    end

    test 'client should not signup without name' do
      params = { email: 'new@emmail.com', password: 'password' }
      post v1_auth_signup_url, params: params
      assert_response :unprocessable_entity
    end

    # request email confirmation with redirect uri for the confirm link
    test 'client should request confirmation email' do
      assert_enqueued_jobs 1 do
        params = { email: @client.email, redirect_to: @redirect_url }
        post v1_auth_request_confirm_url, params: params
      end
      assert_response :success
    end

    test 'client should confirm with token' do
      post v1_auth_confirm_url, params: { token: @client.jwt }
      assert_response :success
      token = JSON.parse(@response.body)['data']['attributes']['token']
      assert Client.decode_jwt(token)
    end

    test 'client should not confirm after two clients switching emails' do
      token = @client.jwt
      switch_email(@client, @client_2)
      post v1_auth_confirm_url, params: { token: token }
      assert_response :gone
      assert_no_match(/token/, @response.body)
      assert_not @client.confirmed?
      assert_not @client_2.confirmed?
    end

    test 'client should request password reset' do
      assert_enqueued_jobs 1 do
        params = { email: @client.email, redirect_to: @redirect_url }
        post v1_auth_request_reset_url, params: params
      end
      assert_response :success
    end

    test 'client should reset the password with token' do
      params = { reset_password_token: @client.jwt, password: 'ttt' }
      post v1_auth_reset_url, params: params
      assert_response :success
      token = JSON.parse(@response.body)['data']['attributes']['token']
      assert Client.decode_jwt(token)
      @client.reload
      assert @client.authenticate('ttt')
    end

    test 'client user account should signin client user account with token' do
      payload = { uid: 32, cid: @client.cid }
      params = { cid: @client.cid, token: @client.jwt(payload, @client.secret) }
      post v1_auth_signin_client_account_url, params: params
      assert_response :success
      token = JSON.parse(@response.body)['token']
      assert Account.decode_jwt(token)
    end
  end
end
