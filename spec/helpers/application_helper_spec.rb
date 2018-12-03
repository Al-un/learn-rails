# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '.display_text' do
    let(:short_text) { 'Lorem ipsum dolor' }
    let(:long_text) {
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
      Nulla pretium volutpat condimentum. Nullam fringilla tincidunt condimentum. 
      Nullam sollicitudin tortor vitae vehicula bibendum. Integer efficitur erat
       a quam convallis, et dignissim turpis viverra. Suspendisse scelerisque, 
       nunc ac egestas eleifend, nisi ligula dignissim erat, non sodales metus 
       ante id sapien. Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
       Ut eleifend enim ac sollicitudin consectetur. Cras facilisis elit nec velit
        faucibus fermentum. Cras ut cursus tellus. Etiam pretium et tellus id ultricies. 
        Suspendisse eu vulputate lectus, id mollis lectus. Vestibulum dictum tincidunt i
        mperdiet. Sed consequat nulla lectus, dapibus volutpat justo commodo ut.'
    }

    context 'when text is nil without no-text option' do
      it 'returns a no-text <span>' do
        result = "<span class=\"no-text\"></span>"
        expect(helper.display_text(nil)).to eq(result)
      end
    end

    context 'when text is nil with a no-text option' do
      it 'returns the no-text' do
        no_text = 'this is the no-text'
        result = "<span class=\"no-text\">#{no_text}</span>"
        expect(helper.display_text(nil, no_text: no_text)).to eq(result)
      end
    end

    context 'when no options is provided' do
      context 'when text is short' do
        it 'returns text' do
          expect(helper.display_text(short_text)).to eq(short_text)
        end
      end
      context 'when text is long ' do
        it 'returns text' do
          expect(helper.display_text(long_text)).to eq(long_text)
        end
      end
    end

    context 'with truncate option' do
      context 'when text is short' do
        it 'returns text' do
          truncated_text = helper.display_text(short_text, truncate: 25)
          expect(truncated_text).to eq(short_text)
        end
      end
      context 'when text is long ' do
        it 'is truncated' do
          truncated_text = helper.display_text(long_text, truncate: 25)
          expect(truncated_text).to eq('Lorem ipsum dolor sit ...')
        end
      end
    end
  end
end
