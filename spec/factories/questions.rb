FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "QuestionTitle#{n}" }
    sequence(:body) { |n| "QuestionBody#{n}" }

    association :author, factory: :user
    trait :invalid do
      title { nil }
    end
  end
end
