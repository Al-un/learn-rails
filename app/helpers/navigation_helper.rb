module NavigationHelper

  # If not logged in, display the sign-in link otherwise display profile menu
  def nav_auth_menu_path
    if session.key?(:userinfo)
      'layouts/navigation/logged_in_menu'
    else
      'layouts/navigation/sign_in_menu'
    end
  end

end
