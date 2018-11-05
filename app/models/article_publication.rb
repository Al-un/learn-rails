class ArticlePublication < ApplicationRecord
  belongs_to :article
  belongs_to :catalog
  accepts_nested_attributes_for :article
  accepts_nested_attributes_for :catalog
end
