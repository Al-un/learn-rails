# frozen_string_literal: true

# Catalag related helping methods
module CatalogsHelper
  include Shared::ControllerHelper

  # https://stackoverflow.com/questions/4821435/ruby-on-rails-helper-method-html-is-displayed-as-plain-text
  # Creating a catalog requires being logged in
  def create_catalog_link
    if authenticated?
      get_button_link(path: new_catalog_path, text_key: 'catalogs.crud.create', icon: 'fa-plus')
    else
      ('<p>' + t('catalogs.crud.sign_in_to_create') + '</p>').html_safe
    end
  end
end
