# frozen_string_literal: true

require 'net/http'
require 'uri'

# https://auth0.com/docs/quickstart/backend/rails#configure-auth0-apis
# module naming convention: https://stackoverflow.com/a/47119792/4906586
module Auth0
  # Auth0 token manager
  class JsonWebToken
    def self.verify(token)
      # https://github.com/jwt/ruby-jwt/
      Rails.logger.debug 'Verifying token', token
      options = {algorithm: 'RS256',
                 iss: "https://#{ENV['AUTH0_DOMAIN']}/",
                 aud: ENV['AUTH0_API_AUDIENCE'],
                 verify_iss: true,
                 verify_aud: true}
      # nil key, true=verify signature
      JWT.decode(token, nil, true, options) do |header|
        puts '-----'
        puts header
        puts '-----'
        jwks_hash[header['kid']]
      end
    end

    def self.jwks_hash
      jwks_raw = Net::HTTP.get URI("https://#{ENV['AUTH0_DOMAIN']}/.well-known/jwks.json")
      jwks_keys = Array(JSON.parse(jwks_raw)['keys'])
      Hash[
        jwks_keys.map do |k|
          [
            k['kid'],
            OpenSSL::X509::Certificate.new(
              Base64.decode64(k['x5c'].first)
            ).public_key
          ]
        end
      ]
    end
  end
end
