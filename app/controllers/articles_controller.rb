# frozen_string_literal: true

# Handling articles entities
class ArticlesController < EntityController
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show, :search]

  # def initialize
  #   super
  # end

  # -[V2]-----------------------------------------------------------------------

  def index
    @articles = Article.all
    respond(@articles, json_opts: {include: [:user]})
  end

  def show
    @article = Article.includes(:user, article_publications: :article)
                      .find(params[:id])
    respond(@article)
  end

  def new
    @article = Article.new
    respond(@article)
  end

  def create
    @article = Article.create!(article_params) do |article|
      article.user = @user
    end
    logger.debug 'Created', article: @article
    respond(@article, resp_html: -> { redirect_to @article, success: 'Created !' })
  end

  def edit
    @article = Article.includes(:user, article_publications: :article)
                      .find(params[:id])
    respond(@article)
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)
    @article.pictures.attach(params[:pictures])
    logger.debug 'Updated', article: @article

    respond(@article, resp_html: -> { redirect_to @article, success: 'Updated!' })
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    respond(article,
            resp_html: -> { redirect_to articles_path, flash: {success: 'Deleted!'} },
            json: {success: true})
  end

  def delete_picture
    logger.debug "Deleting picture #{params[:pic_id]} from article #{params[:id]}"
    @entity = Article.find(params[:id])
    @entity.pictures.find_by_id(params[:pic_id]).purge

    respond_to do |format|
      format.html do
        flash[:info] = 'Picture is removed'
        redirect_to @entity
      end
      format.js
      format.json { json_render_entity(@entity) }
    end
  end

  # # ----------------------------------------------------------------------------
  # # Articles lazy load users
  # def fetch_all_entities
  #   Article.all.includes(:user)
  # end

  # def fetch_by_params_id
  #   Article
  #     .includes(:user, article_publications: :catalog)
  #     .find(params[:id])
  # end

  # # Assign current user to article
  # def create_entity
  #   Article.create!(article_params) do |article|
  #     article.user = @user
  #   end
  # end

  # # Update an article
  # def update_entity
  #   article = Article.find(params[:id])
  #   article.update(article_params)
  #   article.pictures.attach(params[:pictures])

  #   article
  # end

  # ----------------------------------------------------------------------------

  # Search article(s) by:
  # - its name
  def search
    @searched_list = Article.for_name(params[:name])
    logger.debug "Searching articles with #{params} got: #{@searched_list}"

    respond_to do |format|
      format.js do
        @partial_path = params[:partial_path]
        @source_id = params[:source_id]
        render 'articles/search'
      end
      format.json { render json: @searched_list }
    end
  end

  # def json_render_list(list)
  #   render json: list, include: [:user]
  # end

  # def json_render_entity(entity)
  #   render json: entity
  # end

  private # --------------------------------------------------------------------

  def article_params
    params.require(:article).permit(:name, :description, pictures: [])
  end
end
