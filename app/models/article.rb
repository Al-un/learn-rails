class Article < ApplicationRecord

  # associations
  has_many :article_publications, inverse_of: :article, dependent: :destroy
  has_many :catalogs, through: :article_publications
  # associations: users
  # [TMP-001] optional: true https://stackoverflow.com/a/35775686/4906586
  belongs_to :user, optional: true

  # validations
  validates_presence_of :name

end
