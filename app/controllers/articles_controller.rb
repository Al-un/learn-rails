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

    article
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

  private # --------------------------------------------------------------------

  def article_params
    params.require(:article).permit(:name, :description)
  end
end
