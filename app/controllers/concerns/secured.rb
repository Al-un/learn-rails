module Secured 
  extend ActiveSupport::Concern
  
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
      raise RuntimeError, "Cannot check logged_in? for unknown format:#{req_format}"
    end
  end

  private # --------------------------------------------------------------------

  # Fetch Authorization token, if present
  def http_authorization_token
    auth_header = request.headers['Authorization']
    if auth_header.present?
      auth_header.split(' ').last
    end
  end

  # Decode authorization token
  def auth_token
    Auth0::JsonWebToken.verify(http_authorization_token)
  end

  # Fetch logged-in user
  # [TODO] may not be optimal but it is tolerable for this project
  def get_logged_user(user_external_id)
    logger.debug 'Logged user is ' + user_external_id
    User.first_or_create!(auth0_id: user_external_id)
  end

  # Check restricted access for web browsing
  def check_logged_in_web
    return if ENV['OFFLINE_MODE']

    userinfo = session[:userinfo]
    if userinfo.present?
      @user = get_logged_user(userinfo['uid'])
      logger.trace "[Auth/Web] User #{@user.auth0_id} is logged"
    else
      logger.info '[Auth/HTML] User redirected to authentication page'
      redirect_to '/auth/auth0'
    end
  end

  # Check restricted access for API access (JSON only)
  def check_logged_in_json
    return if ENV['OFFLINE_MODE']

    # check if Bearer is here
      @auth_payload, @auth_header = auth_token
      @user = get_logged_user(@auth_payload[:sub])
    rescue JWT::VerificationError, JWT::DecodeError => err
      logger.info `[Auth/JSON] Error: #{err}`
      render json: { errors: ['Authentication error'] }, status: :unauthorized
  end

end
