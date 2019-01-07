# frozen_string_literal: true

# @node Check +responders+ gem relevancy => custom responder used
#
# @abstract
#
# Source:
# - Execute actions before loading method:
# https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one
class EntityController < ApplicationController
  include Secured
  include ExceptionHandler
  include Renderer
end
