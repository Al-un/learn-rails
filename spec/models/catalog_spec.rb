# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Catalog, type: :model do
  # --- Factory testing
  it 'has a valid Factory' do
    expect(build(:catalog)).to be_valid
  end
end
