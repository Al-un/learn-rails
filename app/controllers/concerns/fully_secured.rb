# frozen_string_literal: true

# Module for controllers where all methods are secured
module FullySecured
  extend ActiveSupport::Concern
  include Secured

  included do
    before_action :logged_in?
  end
end
