# frozen_string_literal: true

# Picture
class PictureSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  # mandatory attributes
  attributes :id, :url

  # picture ID
  def id
    # actually forwarded to object.attachment.id
    object.id
  end

  # picture public URL, valid for a short moment only
  def url
    rails_blob_path(object, only_path: true)
  end
end
