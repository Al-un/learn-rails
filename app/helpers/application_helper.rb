# frozen_string_literal: true

# global application helper
# @see NavigationHelper
module ApplicationHelper
  include NavigationHelper

  # @todo move to specific file?
  # @param [String] text to be displayed text
  # @param [String] no_text text to be display if text is nil/empty
  # @param options [Number] truncate truncating length
  def display_text(text, no_text: '', **options)
    # no text
    if text.nil? || text.empty?
      return "<span class=\"lowlight-text\">#{no_text}</span>".html_safe
      # no text options
    elsif options.empty?
      return text
    end

    # truncate if necessary
    if options.key?(:truncate)
      text.truncate(options[:truncate], omission: '...')
    # no valid option
    else
      text
    end
  end
end
