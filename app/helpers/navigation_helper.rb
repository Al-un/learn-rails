# frozen_string_literal: true

# Helper for navigation related components
module NavigationHelper
  include Shared::BasicHelper

  # If not logged in, display the sign-in link otherwise display profile menu
  #
  # @return logged-in menu or sign-in menu partial path
  def nav_auth_menu_path
    if authenticated?
      'layouts/navigation/logged_in_menu'
    else
      'layouts/navigation/sign_in_menu'
    end
  end
end
