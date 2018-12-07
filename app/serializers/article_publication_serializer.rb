# frozen_string_literal: true

class ArticlePublicationSerializer < ActiveModel::Serializer
  # mandatory attributes
  attribute :id
  attribute :article
  attribute :catalog
end
