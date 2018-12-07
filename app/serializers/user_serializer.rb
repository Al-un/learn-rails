# frozen_string_literal: true
# Users do not need created/updated date
class UserSerializer < ActiveModel::Serializer
  # mandatory attributes
  attributes :id, :auth0_id
end
