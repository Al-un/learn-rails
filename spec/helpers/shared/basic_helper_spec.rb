# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shared::BasicHelper, type: :helper do
  describe '.span' do
    # [TODO] challenge html_safe?
    it 'properly surround text' do
      text = 'some <a> text'
      result = "<span>#{text}</span>"
      expect(helper.span(text)).to eq(result)
    end
  end
end
