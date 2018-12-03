# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Static pages', :type => :routing do
  it 'has misc-info pages' do
    expect(get('/misc-info')).to route_to('statics#misc_info')
  end
end
