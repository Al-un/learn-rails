# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  # --- Factory testing
  it 'has a valid Factory' do
    expect(build(:article)).to be_valid
  end
end
