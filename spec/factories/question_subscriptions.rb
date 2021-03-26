FactoryBot.define do
  factory :question_subscription do
    association :user, factory: :user
    association :question, factory: :question
  end
end
