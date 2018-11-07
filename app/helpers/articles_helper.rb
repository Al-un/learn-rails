module ArticlesHelper
  include Shared::ControllerHelper

  # Creating a catalog requires being logged in
  def create_article_link
    if session.key?(:userinfo)
      get_button_link(path: new_article_path, text_key: 'articles.crud.create')
    else
      ('<p>' + t('articles.crud.sign_in_to_create') + '</p>').html_safe
    end
  end

end
