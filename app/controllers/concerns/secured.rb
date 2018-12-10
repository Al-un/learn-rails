# frozen_string_literal: true

# Methods to check user authorization for a given method
module Secured
  extend ActiveSupport::Concern

  # Check if the current session is a logged in session.
  #
  # @see .check_logged_in_web
  # @see .check_logged_in_json
  # @return [nil,Error] nothing if everything is alright or HTML-redirection to
  # login page / JSON-error if any authentication is missing or wrong
  def logged_in?
    ## different behaviour per format
    req_format = request.format

    # HTML browsing / JS (Ajax) rendering
    if req_format.html? || req_format.js?
      check_logged_in_web
      # JSON request
    elsif req_format.json?
      check_logged_in_json
      # Unknown format
    else
      raise "Cannot check logged_in? for unknown format:#{req_format}"
    end
  end

  private # --------------------------------------------------------------------

  # Fetch Authorization token, if present
  #
  # @return [String,nil] Authorization header if present
  def http_authorization_token
    auth_header = request.headers['Authorization']
    return auth_header.split(' ').last if auth_header.present?
  end

  # Decode authorization token
  def auth_token
    Auth0::JsonWebToken.verify(http_authorization_token)
  end

  # Fetch logged-in user
  # @todo may not be optimal but it is tolerable for this project
  def get_logged_user(user_external_id)
    User.first_or_create!(auth0_id: user_external_id)
  end

  # Check restricted access for web browsing
  def check_logged_in_web
    userinfo = session[:userinfo]
    # missing authenticated information
    unless userinfo.present?
      logger.info '[Auth/HTML] User redirected to authentication page'
      return redirect_to '/auth/auth0'
    end
    # Try to decode token
    token = userinfo.dig('credentials', 'token')
    Auth0::JsonWebToken.verify(token)

    @user = get_logged_user(userinfo['uid'])
    logger.debug "[Auth/Web] User #{@user.auth0_id} is logged"
  rescue JWT::VerificationError, JWT::DecodeError => err
    logger.warn "[Auth/HTML] Error: #{err.message}"
    flash[:danger] = 'Not authorized'
    # https://stackoverflow.com/a/46293172/4906586
    redirect_back(fallback_location: root_path)
  end

  # Check restricted access for API access (JSON only)
  def check_logged_in_json
    # check if Bearer is here
    @auth_payload, @auth_header = auth_token
    # logger.debug 'Auth_token: ' + auth_token.to_s + ' => ' + @auth_payload['sub'].to_s
    @user = get_logged_user(@auth_payload['sub'])
  rescue JWT::VerificationError, JWT::DecodeError => err
    logger.warn "[Auth/JSON] Error: #{err}"
    render json: {errors: ['Authentication error']}, status: :unauthorized
  end
end
