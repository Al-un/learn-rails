# frozen_string_literal: true

module Shared
  # Some convenient methods
  module BasicHelper
    # Surround a text with +<span>+ tags and returned it through the +html_safe+
    # pipe to be accepted by Rails
    #
    # @param [String] text to be displayed text
    # @return display ready +<span>+ tag
    def span(text)
      "<span>#{text}</span>".html_safe
    end
  end
end
