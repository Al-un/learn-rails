# Managing catalogs
class CatalogsController < ApplicationController
  include Secured

  # ----------------------------------------------------------------------------
  # display only is opened to public
  before_action :logged_in?, except: [:index, :show] 

  # ----------------------------------------------------------------------------
  # GET /catalogs
  def index
    @catalogs = Catalog.all.includes(:article_publications)

    respond_to do |format|
      format.html
      format.json { render json: @catalogs }
    end
  end

  # GET /catalogs/new
  def new
    @catalog = Catalog.new
    @articles = Article.all

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

  # POST /catalogs
  def create
    @catalog = Catalog.create!(catalog_params) do |c|
      c.user = @user
    end
    
    respond_to do |format|
      format.html { redirect_to catalog_path(@catalog) }
      format.json { render json: @catalog }
    end
  end

  # GET /catalog/:id
  def show
    @catalog = Catalog.includes(article_publications: [:article]).find(params[:id])

    logger.debug({ custom: "Debugging: showing catalogs #{@catalog.id}" })
    logger.info "Info: showing catalogs #{@catalog.id}"
    logger.warn "Warn: showing catalogs #{@catalog.id}"

    begin
      error = wrong_method
    rescue => ex
      logger.warn(ex)
    end

    # Ougai only
    # logger.info('a message', {object: 'an object', another_object: 'another_object'})
    # Logging
    logger.info({msg: 'a message in specific field for Logging', object: 'an object', another_object: 'another_object'})

    respond_to do |format|
      format.html
      format.json { render json: @catalog }
    end
  end

  # GET /catalog/:id/edit
  def edit
    @catalog = Catalog.includes(:user, article_publications: [:article]).find(params[:id])
    @articles = Article.all

    respond_to do |format|
      format.html 
      format.json { render json: @catalog }
    end
  end

  # PUT/PATCH /catalog/:id
  def update
    @catalog = Catalog.find(params[:id])

    @catalog.update(catalog_params)

    # [TMP-001]
    if @catalog.user == nil then
      @catalog.update(user: @user)
    end
    
    respond_to do |format|
      format.html { redirect_to catalog_path(@catalog) }
      format.json { head :no_content }
    end
  end

  # DELETE /catalog/:id
  def destroy
    # Proceed
    catalog = Catalog.find(params[:id])
    catalog.destroy
    respond_to do |format|
      format.html { redirect_to catalogs_path }
      format.json { head :no_content }
    end
    # Exception management
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to catalogs_path }
      format.json { head :no_content, status: :not_found }
    end
  rescue ActiveRecord::RecordNotDestroyed
    respond_to do |format|
      format.html { redirect_to catalogs_path }
      format.json { head :no_content, status: :internal_server_error }
    end
  end

  private # --------------------------------------------------------------------

  def catalog_params
    # http://patshaughnessy.net/2014/6/16/a-rule-of-thumb-for-strong-parameters
    params.require(:catalog).permit(:code, :name, :description,
      article_publications_attributes: [
        :id, :_destroy, # https://github.com/nathanvda/cocoon#strong-parameters-gotcha
        :article_id
      ])
    # params.require(:catalog).permit(:code, :name, :description,
    #   article_publications_attributes: [
    #     :id, :_destroy, # https://github.com/nathanvda/cocoon#strong-parameters-gotcha
    #     article_attribute: [:name, :description]],
    #   :article_ids => [])
  end

  def wrong_method
    a = 1
    b = 0
    a/b
  end

end
