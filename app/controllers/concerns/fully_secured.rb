module FullySecured
  extend ActiveSupport::Concern
  include Secured
  
  included do
    before_action :logged_in?
  end
    
end