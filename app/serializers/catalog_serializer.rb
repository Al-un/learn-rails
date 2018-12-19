# frozen_string_literal: true
# Serialize a single article
class CatalogSerializer < ActiveModel::Serializer
  include ActionView::Helpers::UrlHelper

  # mandatory attributes
  attributes :id, :code, :name
  # optional attributes
  attribute :description, unless: -> { object.description.nil? }
  # optional attributes
  attribute :picture_url, if: -> { object.picture.attached? }
  # associations
  belongs_to :user
  has_many :article_publications
  # computed attributes
  attributes :publications_count

  def publications_count
    object.article_publications.count
  end

  def picture_url
    Rails.application.routes.url_helpers.rails_blob_path(object.picture, only_path: true)
  end
end
