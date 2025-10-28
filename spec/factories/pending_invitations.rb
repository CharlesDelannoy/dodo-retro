FactoryBot.define do
  factory :pending_invitation do
    association :team
    sequence(:email) { |n| "invited#{n}@example.com" }
    association :inviter, factory: :user
    status { "pending" }
  end
end
