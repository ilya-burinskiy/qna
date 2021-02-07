FactoryBot.define do
  factory :question do
    title { "QuestionTitle" }
    body { "QuestionBody" }

    association :author, factory: :user
    trait :invalid do
      title { nil }
    end
  end
end
