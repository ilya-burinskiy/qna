FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question
  end

  trait :invalid do
    body { nil }
  end
end
