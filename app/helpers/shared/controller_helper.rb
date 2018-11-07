module Shared
  # Some common methods for controllers
  module ControllerHelper

    # generate a button link
    # @param path: path name
    # @param text_key: to display translated value
    def get_button_link(path:, text_key:)
      button_to path, method: 'get' do
        ('<span><i class="fas fa-plus"></i>' + t(text_key) + '</span>').html_safe
      end
    end

  end
end
