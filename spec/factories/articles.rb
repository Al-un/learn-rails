FactoryBot.define do
  factory :article do
    name { Faker::Creature::Animal.name }
    description { Faker::Lorem.paragraph }
  end
end
