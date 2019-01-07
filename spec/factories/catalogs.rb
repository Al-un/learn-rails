FactoryBot.define do
  factory :catalog do
    code { Faker::String.random(6) }
    name { Faker::Artist.name }
    description { Faker::Lorem.paragraph }
    # ensure a non-null user but it should be replaced by an existing user
    association :user, factory: :user
  end
end
