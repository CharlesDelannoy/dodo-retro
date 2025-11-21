FactoryBot.define do
  factory :ticket do
    retrospective { nil }
    retrospective_column { nil }
    author { nil }
    content { "MyText" }
  end
end
