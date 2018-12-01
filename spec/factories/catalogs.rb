FactoryBot.define do
  factory :catalog do
    code { Faker::String.random(6) }
    name { Faker::Creature::Animal.name }
    description { Faker::Lorem.paragraph }
  end
end
