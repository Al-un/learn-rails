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
    nil_text = text.nil? || text.empty?
    return "<span class=\"no-text\">#{no_text}</span>".html_safe if nil_text
    # no text options
    return text if options.empty?

    # truncate if necessary
    truncated = options.key?(:truncate)
    return text.truncate(options[:truncate], omission: '...') if truncated

    # no valid option
    text
  end
end
