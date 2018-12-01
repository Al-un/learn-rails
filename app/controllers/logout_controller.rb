# frozen_string_literal: true

# Handling logging out
#
# @todo To merge with Auth0Controller?
class LogoutController < ApplicationController
  include LogoutHelper

  # Logging out current user and redirect to +logout_url+
  def logout
    reset_session
    redirect_to logout_url.to_s
  end
end
