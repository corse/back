# Client Mailer
class ClientsMailer < ApplicationMailer
  def forgot_password(client, callback_url)
    @client = client
    @callback_url = callback_url + '?token=' + @client.jwt
    mail to: client.email, subject: 'Corse: - Forgot your password?'
  end

  def confirm_email(client, callback_url)
    @client = client
    @client.payload[:callback_url] = callback_url
    @callback_url = v1_auth_confirm_url + '?token=' + @client.jwt
    mail to: @client.email, subject: 'Corse: - Please confirm your email'
  end
end
