class Catalog < ApplicationRecord

  # associations: products
  has_many :article_publications, inverse_of: :catalog, dependent: :destroy
  has_many :articles, through: :article_publications 
  accepts_nested_attributes_for :article_publications, allow_destroy: true
  accepts_nested_attributes_for :articles
  # associations: users
  belongs_to :user, inverse_of: :catalogs

  # validations
  validates_presence_of :code, :name

end
