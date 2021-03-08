FactoryBot.define do
  factory :vote, class: 'Vote' do
    status { :for }

    association :voter, factory: :user

    trait :question do
      association :votable, factory: :question
    end

    trait :answer do
      association :votable, factory: :answer
    end

    trait :against do
      status { :against }
    end
  end
end
