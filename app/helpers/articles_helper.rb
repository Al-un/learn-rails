module ArticlesHelper

  # Creating a catalog requires being logged in
  def create_article_link
    if session.key?(:userinfo)
      button_to new_article_path, method: 'get' do
        ('<span><i class="fas fa-plus"></i>' + t('articles.crud.create') + '</span>').html_safe
      end
    else
      ('<p>' + t('articles.crud.sign_in_to_create') + '</p>').html_safe
    end
  end

end
