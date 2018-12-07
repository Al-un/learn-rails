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
    params.require(:catalog).permit(:code, :name, :description)
  end
end
