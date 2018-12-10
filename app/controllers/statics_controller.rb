# frozen_string_literal: true

# controller for static pages
class StaticsController < ApplicationController
  # misc info page:
  # - load authentication info if present
  def misc_info
    if session.key?(:userinfo)
      @access_token = session[:userinfo].dig('credentials', 'token')
      @id_token = session[:userinfo].dig('credentials', 'id_token')
      @expires_at = session[:userinfo].dig('credentials', 'expires_at')
    else
      @access_token = nil
      @id_token = nil
      @expires_at = nil
    end
  end
end
