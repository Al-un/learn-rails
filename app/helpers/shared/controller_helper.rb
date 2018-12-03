# frozen_string_literal: true

module Shared
  # Some common methods for controllers managing entities
  module ControllerHelper
    include BasicHelper

    # generate a button link
    #
    # @param [Method] path path helper name
    # @param [String] text_key to display translated value
    # @param [String] icon FontAwesome icon name
    # @return link in button format
    def get_button_link(path:, text_key:, icon: nil)
      button_to path, method: 'get' do
        icon_content = icon ? "<i class=\"fas #{icon}\"></i>" : ''
        span(icon_content + t(text_key))
      end
    end

    # check if current session is authenticated. Does not check authorization
    # @return [Boolean] true if session is properly authenticated
    def authenticated?
      session.key?(:userinfo)
    end
  end
end
