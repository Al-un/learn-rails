# frozen_string_literal: true

# Handling articles entities
class ArticlesController < EntityController
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show, :search]

  def initialize
    super(Article)
  end

  # ----------------------------------------------------------------------------
  # Articles lazy load users
  def fetch_all_entities
    Article.all.includes(:user)
  end

  def fetch_by_params_id
    Article
      .includes(:user, article_publications: :catalog)
      .find(params[:id])
  end

  # Assign current user to article
  def create_entity
    Article.create!(article_params) do |article|
      article.user = @user
    end
  end

  # Update an article
  def update_entity
    article = Article.find(params[:id])
    article.update(article_params)
    article.pictures.attach(params[:pictures])

    article
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

  def json_render_list(list)
    render json: list, include: [:user]
  end

  def json_render_entity(entity)
    render json: entity
  end

  private # --------------------------------------------------------------------

  def article_params
    params.require(:article).permit(:name, :description, pictures: [])
  end
end
