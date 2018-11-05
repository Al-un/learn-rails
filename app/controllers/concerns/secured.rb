module Secured 
  extend ActiveSupport::Concern
  
  def logged_in?

    ## When using LearZone offline, Auth0 is not available
    if ENV['OFFLINE_MODE']
      logger debug "Application is offline. Logged-in user check skipped"
      return
    end

    ## different behaviour per format
    req_format = request.format

    # HTML browsing
    if req_format.html?
      if session[:userinfo].present?
        @user = get_logged_user(session[:userinfo]['uid'])
        logger.debug "[Auth/HTML] User #{@user.auth0_id} is logged"
      else
        logger.info '[Auth/HTML] User redirected to authentication page'
        redirect_to '/auth/auth0' unless session[:userinfo].present?
      end
    
    # JS (Ajax) rendering
    elsif req_format.js?
      if session[:userinfo].present?
        @user = get_logged_user(session[:userinfo]['uid'])
        logger.debug `[Auth/JS] User #{@user.auth0_id} is logged`
      else
        logger.info '[Auth/JS] User redirected to authentication page'
        redirect_to '/auth/auth0' unless session[:userinfo].present?
      end

    # JSON request
    elsif req_format.json?
      # check if Bearer is here
      begin
        @auth_payload, @auth_header = auth_token
        @user = get_logged_user(@auth_payload[:sub])
      rescue JWT::VerificationError, JWT::DecodeError => err
        logger.info `[Auth/JSON] Error: #{err}`
        render json: { errors: ['Missing authentication'] }, status: :unauthorized
      end
    
    # Unknown format
    else
      logger.error `[Auth/Unknown] unknown format: #{req_format}`
      render json: { errors: ['Invalid format:' + req_format.to_s] }, status: :unauthorized
    end
  end

  private # --------------------------------------------------------------------

  # Fetch Authorization token, if present
  def http_authorization_token
    if request.headers['Authorization'].present?
      request.headers['Authorization'].split(' ').last
    end
  end

  # Decode authorization token
  def auth_token
    Auth0::JsonWebToken.verify(http_authorization_token)
  end

  # Fetch logged-in user
  # [TODO] may not be optimal but it is tolerable for this project
  def get_logged_user(user_external_id)
    Rails.logger.debug 'Logged user is ' + user_external_id
    User.first_or_create!(auth0_id: user_external_id)
  end

end
