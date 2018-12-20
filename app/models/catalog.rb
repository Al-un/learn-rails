# frozen_string_literal: true

# A catalog is a container for articles from where the latter are displayed.
class Catalog < ApplicationRecord
  # associations: products
  has_many :article_publications, inverse_of: :catalog, dependent: :destroy
  has_many :articles, through: :article_publications
  # accepts_nested_attributes_for :article_publications, allow_destroy: true
  # accepts_nested_attributes_for :articles
  # associations: users
  belongs_to :user, inverse_of: :catalogs, optional: false
  # active_storage
  has_one_attached :picture

  # validations
  validates_presence_of :code, :name

  # Scopes
  scope :for_name, -> (name) { where('name like ?', "%#{name}%") }
  scope :for_code, -> (code) { where('code like ?', "%#{code}%") }

  # Lifecycle
  after_initialize do |catalog|
    # This avoid nil exception when display picture as it relies on name
    catalog.name ||= ''
  end
end
