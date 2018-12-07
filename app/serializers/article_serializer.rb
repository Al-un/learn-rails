# frozen_string_literal: true
# Serialize a single article
class ArticleSerializer < ActiveModel::Serializer
  # mandatory attributes
  attributes :id, :name
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
