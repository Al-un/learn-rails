# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shared::ControllerHelper, type: :helper do
  describe '.get_button_link' do
    let(:path) { 'some_path' }
    let(:text_key) { 'test.dummy_key' }
    let(:text_value) { 'Dummy text' }
    let(:icon_key) { 'fa-plus' }
    let(:form_wrapper) do
      proc do |path, text|
        str = "<form class=\"button_to\" method=\"get\" action=\"#{path}\">"
        str += "<button type=\"submit\"><span>#{text}</span></button>"
        str += '</form>'
        str
      end
    end

    context 'without icon' do
      it 'returns icon-less button' do
        button = helper.get_button_link(
          path: path,
          text_key: text_key
        )
        expect(button).to eq(form_wrapper.call(path, text_value))
      end
    end

    context 'with icon' do
      it 'returns iconed button' do
        button = helper.get_button_link(
          path: path,
          text_key: text_key,
          icon: icon_key
        )
        iconed_text = "<i class=\"fas #{icon_key}\"></i>"
        expect(button).to eq(form_wrapper.call(path, iconed_text + text_value))
      end
    end
  end

  describe '.authenticated?' do
    pending 'Waiting for Auth0 testing'
  end
end
