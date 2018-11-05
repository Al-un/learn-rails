class User < ApplicationRecord

  # associations: products
  has_many :articles, inverse_of: :user
  has_many :catalogs, inverse_of: :user

  # validations
  # https://guides.rubyonrails.org/active_record_validations.html
  validates :auth0_id, uniqueness: { case_sensitive: false }

  # Override to_s display
  def to_s
    auth0_id
  end
  
end
