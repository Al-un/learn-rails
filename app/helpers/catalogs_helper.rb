module CatalogsHelper

  # https://stackoverflow.com/questions/4821435/ruby-on-rails-helper-method-html-is-displayed-as-plain-text
  # Creating a catalog requires being logged in
  def create_catalog_link
    if session.key?(:userinfo)
      button_to new_catalog_path, method: 'get' do
        ('<span><i class="fas fa-plus"></i>' + t('catalogs.crud.create') + '</span>').html_safe
      end
    else
      ('<p>' + t('catalogs.crud.sign_in_to_create') + '</p>').html_safe
    end
  end

end
