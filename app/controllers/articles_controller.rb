# Handling articles exposition with articles within catalogs (index & show only)
class ArticlesController < ApplicationController
  include Secured

  # https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one
  before_action :load_article, only: [:show, :edit, :update, :destroy]
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show] 

  # GET /articles
  # Need to check if getting articles from a catalog or not
  def index
    if (params.has_key?(:catalog_id))
      @articles = Catalog.find(params[:catalog_id]).articles
    else
      @articles = Article.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @articles }
    end
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # POST /articles
  def create
    @article = Article.create!(article_params) do |a|
      a.user = @user
    end
    
    respond_to do |format|
      format.html { redirect_to article_path(@article) }
      format.json { render json: @article }
    end
  end

  # GET /article/:id/edit
  # Need to check if getting articles from a catalog or not
  def edit
    @article = Article.find(params[:id])
    # if (params.has_key?(:catalog_id))
    #   @article = Catalog.find(params[:catalog_id]).articles.find(params[:id])
    # else
    #   @article = Article.find(params[:id])
    # end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @article }
    end
  end

  # PATCH /article/:id 
  # !! This is not PUT !!
  def update
    @article.update(article_params)

    # [TMP-001]
    if @article.user == nil then
      @article.update(user: @user)
    end

    respond_to do |format|
      format.html { redirect_to articles_path }
      format.json { head :no_content }
    end
  end

  # DELETE /article/:id
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_path }
      format.json { head :no_content }
    end
  end

  private # --------------------------------------------------------------------

  def article_params
    params.require(:article).permit(:name, :description)
  end

  def load_article
    @article = Article.find(params[:id])
  end

end
