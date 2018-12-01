FactoryBot.define do
  factory :user do
    sequence(:auth0_id) { |n| "auth0|#{format('%015d', n)}" }
  end
end
