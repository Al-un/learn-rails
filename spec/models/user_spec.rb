# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Display' do
    it 'to_s display auth0_id' do
      user = User.new
      auth0id = 'auth0|this_is_an_id'
      user.auth0_id = auth0id
      expect(user.to_s).to eq(auth0_id)
    end
  end
end
