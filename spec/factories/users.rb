FactoryBot.define do
  factory :user do
    sequence(:auth0_id) { |n| "auth0|#{format('%015d', n)}" }

    trait :with_products do
      # ensure a count of articles/catalogs is defined
      transient do
        articles_count { 10 }
        catalogs_count { 10 }
      end

      after(:create) do |user, evaluator|
        articles = create_list(:article, evaluator.articles_count, user: user)
        catalogs = create_list(:catalog, evaluator.catalogs_count, user: user)
        # TODO: add publications
      end
    end
  end
end
