# frozen_string_literal: true


module Shared
  # Some common methods for controllers managing entities
  module ControllerHelper

    # generate a button link
    #
    # @param [Method] path path helper name
    # @param [String] text_key to display translated value
    def get_button_link(path:, text_key:)
      button_to path, method: 'get' do
        ('<span><i class="fas fa-plus"></i>' + t(text_key) + '</span>').html_safe
      end
    end

  end
end
