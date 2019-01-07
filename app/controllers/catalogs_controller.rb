# frozen_string_literal: true

# Managing catalogs
class CatalogsController < EntityController
  # ----------------------------------------------------------------------------
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show]

  def index
    @catalogs = Catalog.all
    respond(@catalogs, json_opts: {include: [:user]})
  end

  def show
    @catalog = Catalog.includes(:user, article_publications: :article)
                      .find(params[:id])
    respond(@catalog)
  end

  def new
    @catalog = Catalog.new
    respond(@catalog)
  end

  def create
    @catalog = Catalog.create!(catalog_params) do |catalog|
      catalog.user = @user
    end
    logger.debug 'Created', catalog: @catalog
    respond(@catalog, resp_html: -> { redirect_to @catalog, success: 'Created !' })
  end

  def edit
    @catalog = Catalog.includes(:user, article_publications: :article)
                      .find(params[:id])
    respond(@catalog)
  end

  def update
    @catalog = Catalog.find(params[:id])
    @catalog.update(catalog_params)
    logger.debug 'Updated', catalog: @catalog

    respond(@catalog, resp_html: -> { redirect_to @catalog, success: 'Updated!' })
  end

  def destroy
    catalog = Catalog.find(params[:id])
    catalog.destroy
    respond(catalog,
            resp_html: -> { redirect_to catalogs_path, flash: {success: 'Deleted!'} },
            json: {success: true})
  end

  def delete_picture
    logger.debug "Deleting picture from catalog #{params[:id]}"
    @catalog = Catalog.find(params[:id])
    @catalog.picture.purge

    respond(@catalog,
            resp_html: -> { redirect_to @catalog, flash: {success: 'Deleted!'} })
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

  private # --------------------------------------------------------------------

  # Filter catalogs parameters
  def catalog_params
    params.require(:catalog).permit(:code, :name, :description, :picture)
  end
end
