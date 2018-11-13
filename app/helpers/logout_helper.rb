# frozen_string_literal: true

# Helper for logging out (Auth0 specific) components
module LogoutHelper
  # Fetching logging out URL for Auth0
  #
  # @return [String] logging out Auth0 URL
  def logout_url
    domain = ENV['AUTH0_DOMAIN']
    client_id = ENV['AUTH0_CLIENT_ID']
    request_params = {
      returnTo: root_url,
      client_id: client_id
    }
    # domain = Rails.application.secrets.auth0_domain
    # client_id = Rails.application.secrets.auth0_client_id
    # request_params = {
    #   returnTo: root_url,
    #   client_id: client_id
    # }

    URI::HTTPS.build(host: domain, path: '/v2/logout', query: to_query(request_params))
  end

  private

  # Convert hash parameter into a concatenated String parameters
  #
  # @param [Hash] hash parameters Hash format
  # @return [String] parameters String format
  def to_query(hash)
    hash.map { |k, v| "#{k}=#{URI.escape(v)}" unless v.nil? }.reject(&:nil?).join('&')
  end
end