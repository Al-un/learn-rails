FactoryBot.define do
  factory :user do
      sequence(:auth0_id) { |n| "auth0|#{format("%015", n)}" }
  end
end