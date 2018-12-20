# frozen_string_literal: true

# Managing catalogs
class CatalogsController < EntityController
  # ----------------------------------------------------------------------------
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show]

  def initialize
    super(Catalog)
  end

  # ----------------------------------------------------------------------------
  # Catalogs lazy load users
  def fetch_all_entities
    Catalog.all.includes(:article_publications, :user)
  end

  def fetch_by_params_id
    Catalog
      .includes(:user, article_publications: :article)
      .find(params[:id])
  end

  # Assign current user to catalog
  def create_entity
    Catalog.create!(catalog_params) do |catalog|
      catalog.user = @user
    end
  end

  # Update a catalog
  def update_entity
    catalog = Catalog.find(params[:id])
    catalog.update(catalog_params)

    catalog
  end

  # Prepare the creation of a new entity
  def new
    @entity = Catalog.new
    @entity.name = '' # to avoid nil exception for picture

    respond_to do |format|
      format.html
      format.js
      format.json { json_render_entity(@entity) }
    end
  end

  def delete_picture
    logger.debug "Deleting picture from catalog #{params[:id]}"
    @entity = Catalog.find(params[:id])
    @entity.picture.purge

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
  # - name
  # - code
  def search
    @searched_list = Catalog.for_name(params[:name])
                            .for_code(params[:code])
    logger.debug "Searching catalogs with #{params} got: #{@searched_list}"

    respond_to do |format|
      format.js do
        @partial_path = params[:partial_path]
        @source_id = params[:source_id]
        render 'catalogs/search'
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

  # Filter catalogs parameters
  def catalog_params
    params.require(:catalog).permit(:code, :name, :description, :picture)
  end
end
