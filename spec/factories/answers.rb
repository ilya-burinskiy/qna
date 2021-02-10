FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "AnswerBody#{n}"}

    question
    association :author, factory: :user
  end

  trait :invalid do
    body { nil }
  end
end
