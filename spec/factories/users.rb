FactoryBot.define do
  factory :user do
    # Auth0 users and social users must show no difference so only test
    # with Auth0 users
    sequence(:auth0_id) { |n| "auth0|#{format('%015d', n)}" }

    # Use user as the root element for bunch creating products
    trait :with_products do
      # ensure a count of articles/catalogs is defined
      transient do
        articles_count { 50 }
        catalogs_count { 5 }
        max_publication_count { 25 }
      end

      # user ID is required for foreign key so trigger only after +create+
      after(:create) do |user, evaluator|
        # create articles and catalogs.
        articles = create_list(:article, evaluator.articles_count, user: user)
        catalogs = create_list(:catalog, evaluator.catalogs_count, user: user)
        # publications are random
        catalogs.each do |catalog|
          Random.rand(evaluator.max_publication_count).times do
            # take a random article
            article = articles.sample
            # use a factory in case additional fields are required
            create(:article_publication, catalog: catalog, article: article)
          end
        end
      end
    end
  end
end
