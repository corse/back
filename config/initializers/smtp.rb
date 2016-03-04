Rails.application.configure do
  secrets = Rails.application.secrets
  config.action_mailer.smtp_settings = secrets['smtp_settings'].symbolize_keys
  config.action_mailer.default_options = secrets['default_options'].symbolize_keys
  config.action_mailer.default_url_options =
    secrets['default_url_options'].symbolize_keys
end
