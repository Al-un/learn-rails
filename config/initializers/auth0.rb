# frozen_string_literal: true

# https://github.com/auth0/omniauth-auth0
Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV['AUTH0_CLIENT_ID'],
    ENV['AUTH0_CLIENT_SECRET'],
    ENV['AUTH0_DOMAIN'],
    callback_path: ENV['AUTH0_CALLBACK'],
    authorize_params: {
      audience: ENV['AUTH0_API_AUDIENCE'],
      scope: 'openid profile'
      # prompt: 'none'
    }
  )
end

Rails.application.configure do
  puts ' ---------- Application configuration: Auth0 ----------'
  # Redirect OmniAuth logs to Rails logger
  OmniAuth.config.logger = Rails.logger
end