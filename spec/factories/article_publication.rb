FactoryBot.define do
  factory :article_publication do
    association :article, factory: :article
    association :catalog, factory: :catalog
  end
end
