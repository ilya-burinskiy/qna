FactoryBot.define do
  factory :comment do
    body { 'Comment body' }

    association :author, factory: :user

    trait :question do
      association :commentable, factory: :question
    end

    trait :answer do
      association :commentable, factory: :answer
    end

    trait :invalid do
      body { nil }
    end
  end
end
