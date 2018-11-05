class ArticlePublicationsController < ApplicationController

  # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one
  before_action :load_article_publication, only: [:show, :update, :destroy]

  # GET /article_publications
  def index
    @article_publications = ArticlePublication.all
    json_response(@article_publications)
  end

  # POST /article_publications
  def create
    @article_publication = ArticlePublication.create!(article_publication_params)
    json_response(@article_publication, :created)
  end

  # GET /article_publication/:id
  def show
    json_response(@article_publication)
  end

  # PATCH /article_publication/:id 
  # !! This is not PUT !!
  def update
    @article_publication.update(article_publication_params)
    head :no_content
  end

  # DELETE /article_publication/:id
  def destroy
    @article_publication.destroy
    head :no_content
  end

  private # --------------------------------------------------------------------

  def article_publication_params
    params.permit(:article_id, :catalog_id)
  end

  def load_article_publication
    @article_publication = ArticlePublication.find(params[:id])
  end

end
