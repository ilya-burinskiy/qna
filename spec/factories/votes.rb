FactoryBot.define do
  factory :vote, class: 'Vote' do
    status { 1 }

    association :voter, factory: :user

    trait :question do
      association :votable, factory: :question
    end

    trait :answer do
      association :votable, factory: :answer
    end

    trait :against do
      status { -1 }
    end
  end
end
