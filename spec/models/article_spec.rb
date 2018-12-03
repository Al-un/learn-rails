# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'Scopes' do
    # TMP-002 bad scope testing
    describe '.for_name' do
      it 'has proper query' do
        create(:article, name: 'aabbcc')
        a2 = create(:article, name: 'ababab')
        a3 = create(:article, name: 'bababa')
        create(:article, name: 'cdcdcd')
        expect(Article.for_name('ba').all).to eq([a2, a3])
      end
    end
  end
end
