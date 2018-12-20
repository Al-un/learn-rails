class ArticlePublicationsController < EntityController
  # ----------------------------------------------------------------------------
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show]

  def create
    @article_publication = ArticlePublication.create!(article_publication_params)
    respond(@article_publication)
  end

  def destroy
    # for Ajax update
    @deleted_id = params[:id]
    # delete
    article_publication = ArticlePublication.find(@deleted_id)
    article_publication.destroy
    respond(article_publication)
  end

  private

  def article_publication_params
    params.permit(:article_id, :catalog_id)
  end
end
