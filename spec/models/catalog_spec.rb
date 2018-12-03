# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Catalog, type: :model do
  context 'Scopes' do
    # TMP-002 bad scope testing
    describe '.for_code' do
      it 'has proper query' do
        create(:catalog, code: 'aabbcc')
        c2 = create(:catalog, code: 'ababab')
        c3 = create(:catalog, code: 'bababa')
        create(:catalog, code: 'cdcdcd')
        expect(Catalog.for_code('ba').all).to eq([c2, c3])
      end
    end
    # TMP-002 bad scope testing
    describe '.for_name' do
      it 'has proper query' do
        create(:catalog, name: 'aabbcc')
        c2 = create(:catalog, name: 'ababab')
        c3 = create(:catalog, name: 'bababa')
        create(:catalog, name: 'cdcdcd')
        expect(Catalog.for_name('ba').all).to eq([c2, c3])
      end
    end
  end
end
