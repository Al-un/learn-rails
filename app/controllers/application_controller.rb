# frozen_string_literal: true

# Most basic controller class
class ApplicationController < ActionController::Base
  # https://gist.github.com/maxivak/a25957942b6c21a41acd
  # CRSF verification skipped for JSON request only
  skip_before_action :verify_authenticity_token, if: :json_request?

  # Custom flash
  add_flash_types :error, :success, :info

  # Lograge method for adding extra info to Logging
  # https://coderwall.com/p/9x0h6a/better-rails-logging-user_id-remote_ip-with-lograge-on-heroku
  #
  # @param [Hash] payload payload to append extra information
  def append_info_to_payload(payload)
    super
    payload[:remote_ip] = request.remote_ip
  end

  private

  # Check if request is a JSON request.
  #
  # For some reasons, cannot directly use +request.format.json?+ in
  # +skip_before_action+
  #
  # @return [Boolean] true if incoming request is a JSON request
  def json_request?
    request.format.json?
  end
end
