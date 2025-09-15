FactoryBot.define do
  factory :participant do
    association :team
    association :user
  end
end
