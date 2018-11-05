# frozen_string_literal: true

module ApplicationHelper
  include NavigationHelper

  # [TODO] move to specific file?
  # text          : to be displayed text
  # no_text       : text to be display if text is nil/empty
  # text_options  : optional text formatting options
  #                 > :truncate => {truncating length}
  def display_text(text, no_text: '', **text_options)
    # no text
    if text.nil? || text.empty?
      return "<span class=\"lowlight-text\">#{no_text}</span>".html_safe
      # no text options
    elsif text_options.empty?
      return text
    end

    # truncate if necessary
    if text_options.key?(:truncate)
      text.truncate(text_options[:truncate], omission: '...')
    # no valid option
    else
      text
    end
  end
end
