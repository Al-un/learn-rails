class ArticlePublicationsController < EntityController
  # ----------------------------------------------------------------------------
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show]

  def initialize
    super(ArticlePublication, model_path: 'article_publication')
  end

  # ----------------------------------------------------------------------------
  def fetch_all_entities
    if params.key?(:catalog_id)
      ArticlePublication.where(catalog_id: params[:catalog_id])
    elsif params.key?(:article_id)
      ArticlePublication.where(article_id: params[:article_id])
    end
  end

  def entity_new
    article_publication = ArticlePublication.new

    if params.key?(:catalog_id)
      article_publication.catalog = Catalog.find(params[:catalog_id])
    elsif params.key?(:article_id)
      article_publication.article = Article.find(params[:article_id])
    end

    article_publication
  end

  def create_entity
    ArticlePublication.create!(article_publication_params)
  end

  def update_entity
    article_publication = ArticlePublication.find(params[:id])
    article_publication.update(article_publication_params)

    article_publication
  end

  def destroy_entity
    @deleted_id = params[:id]
    super
  end

  # # GET /article_publications
  # def index
  #   @article_publications = ArticlePublication.all
  #   json_response(@article_publications)
  # end

  # # POST /article_publications
  # def create
  #   @article_publication = ArticlePublication.create!(article_publication_params)
  #   json_response(@article_publication, :created)
  # end

  # # GET /article_publication/:id
  # def show
  #   json_response(@article_publication)
  # end

  # # PATCH /article_publication/:id
  # # !! This is not PUT !!
  # def update
  #   @article_publication.update(article_publication_params)
  #   head :no_content
  # end

  # # DELETE /article_publication/:id
  # def destroy
  #   @article_publication.destroy
  #   head :no_content
  # end

  # private # --------------------------------------------------------------------

  def article_publication_params
    params.permit(:article_id, :catalog_id)
  end

  # def load_article_publication
  #   @article_publication = ArticlePublication.find(params[:id])
  # end
end
