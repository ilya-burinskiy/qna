FactoryBot.define do
  factory :reward do
    name { "MyString" }

    association :question
    association :author, factory: :user
  end
end
