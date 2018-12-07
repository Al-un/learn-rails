# frozen_string_literal: true
# Serialize a single article
class CatalogSerializer < ActiveModel::Serializer
  # mandatory attributes
  attributes :id, :code, :name
  # optional attributes
  attribute :description, unless: -> { object.description.nil? }
  # associations
  belongs_to :user
  has_many :article_publications
  # computed attributes
  attributes :publications_count

  def publications_count
    object.article_publications.count
  end
end
