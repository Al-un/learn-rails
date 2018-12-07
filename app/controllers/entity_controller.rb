# frozen_string_literal: true

# Abstract/parent class for controller managing a specific model. This class
# is designed to cover basic CRUD functionalities
#
# By convention, the methods order is index, show, new, create, edit, update,
# destroy.
#
# I prefer to split responses, even if it is not DRY, and not using the responders
# gem because the data structure may evolve and a simple +respond_with+ may not
# be enough
#
# @todo Check +responders+ gem relevancy
#
# @abstract
#
# Source:
# - Execute actions before loading method:
# https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one
class EntityController < ApplicationController
  include Secured

  # Initialize the controller based on a model class
  #
  # @param [Class] model_class class of the managed model
  def initialize(model_class, model_path: model_class.name.downcase)
    # empty parenthesis required =>
    # ArgumentError (wrong number of arguments (given 1, expected 0)):
    super()
    # Store model
    @model_class = model_class
    @model_path = model_path

    logger.debug "Initializing controller for model #{@model_class} with path #{model_path}"
  end

  # ---------- CRUD ------------------------------------------------------------

  # Render a list of entities. Subject to pagination
  def index
    @list = fetch_all_entities

    respond_to do |format|
      format.html
      format.js
      format.json { json_render_list(@list) }
    end
  end

  # Render a specific entity based on its primary key
  def show
    @entity = fetch_by_params_id

    respond_to do |format|
      format.html
      format.js
      format.json { json_render_entity(@entity) }
    end
  rescue ActiveRecord::RecordNotFound => exception
    respond_to do |format|
      format.html do
        flash[:error] = exception.message
        redirect_to entities_path
      end
      format.json { head :not_found }
    end
  end

  # Prepare the creation of a new entity
  def new
    @entity = entity_new

    respond_to do |format|
      format.html
      format.js
      format.json { json_render_entity(@entity) }
    end
  end

  # Create (persist in database) a new entity
  def create
    @entity = create_entity

    respond_to do |format|
      format.html { redirect_to entity_path(@entity) }
      format.js
      format.json { json_render_entity(@entity) }
    end
  rescue ActiveRecord::RecordInvalid => exception
    respond_to do |format|
      exception_msg = exception.message
      format.html do
        flash[:error] = exception_msg
        redirect_to new_entity_path
      end
      format.js do
        render_js_exception(exception)
      end
      format.json do
        render json: {error: exception_msg}, status: :bad_request
      end
    end
  end

  # Prepare the update of an existing entity
  def edit
    @entity = fetch_by_params_id

    respond_to do |format|
      format.html
      format.js
      format.json { json_render_entity(@entity) }
    end
  rescue ActiveRecord::RecordNotFound => exception
    respond_to do |format|
      format.html do
        flash[:error] = exception.message
        redirect_to entities_path
      end
      format.json { head :not_found }
    end
  end

  # Update (update in database) an existing entity
  def update
    @entity = update_entity

    respond_to do |format|
      format.html { redirect_to entity_path(@entity) }
      format.js
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordInvalid => exception
    respond_to do |format|
      exception_msg = exception.message
      format.html do
        flash[:error] = exception_msg
        redirect_to entity_path(params[:id])
      end
      format.json do
        render json: {error: exception_msg}, status: :bad_request
      end
    end
  end

  # Destroy (delete from database) an existing entity
  def destroy
    destroy_entity

    respond_to do |format|
      format.html { redirect_to entities_path }
      format.js
      format.json { head :no_content }
    end
  rescue => exception
    respond_to do |format|
      exception_msg = exception.message
      format.html do
        flash[:error] = exception_msg
        redirect_to entities_path
      end
      format.json do
        render json: {error: exception_msg}, status: :bad_request
      end
    end
  end

  # protected

  # ---------- CRUD helper -----------------------------------------------------
  # fetch all entities
  def fetch_all_entities
    @model_class.all
  end

  # Fetch a specific entity
  def fetch_by_params_id
    @model_class.find(params[:id])
  end

  # Serialize a list of entities
  def json_render_list(list)
    render json: list, collection_serializer: CollectionSerializer
  end

  # Serialize a single entity
  def json_render_entity(entity)
    render json: entity
  end

  # Instantiate a new entity
  def entity_new
    @model_class.new
  end

  # Proceed to entity creation from parameters. Child controller must go through
  # strong parameters
  #
  # @return [Model] created entity
  def create_entity
    raise 'Method "create_entity" has to be overridden!'
  end

  # Update an entity. To be implemented in children controllers
  #
  # @return [Model] created entity
  def update_entity
    raise 'Method "create_entity" has to be overridden!'
  end

  # Destroy an entity
  def destroy_entity
    entity = @model_class.find(params[:id])
    entity.destroy
  end

  # ---------- Path helper -----------------------------------------------------

  # Fetch the new entity path. Metaprogramming FTW
  #
  # @return [String] new entity path
  def new_entity_path
    destination_path = 'new_' + @model_path + '_path'
    Rails.application.routes.url_helpers.public_send(destination_path)
  end

  # Fetch the entity path
  #
  # @return [String] entity path for the given entity
  def entity_path(entity)
    destination_path = @model_path + '_path'
    Rails.application.routes.url_helpers.public_send(destination_path, entity)
  end

  # Fetch the entities list path
  #
  # @return [String] entities list path
  def entities_path
    destination_path = @model_path + 's_path'
    Rails.application.routes.url_helpers.public_send(destination_path)
  end

  def render_js_exception(exception)
    @error_msg = exception.message
    render 'shared/error'
  end
end
