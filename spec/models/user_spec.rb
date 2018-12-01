# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  # --- Factory testing
  it 'has a valid Factory' do
    expect(build(:user)).to be_valid
  end
end
