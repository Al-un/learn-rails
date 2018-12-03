# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Authentication link', :type => :routing do
  it 'has logout path with same name' do
    expect(:get => logout_path).to route_to('auth0#logout')
  end
end
