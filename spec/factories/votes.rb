FactoryBot.define do
  factory :question_vote, class: 'Vote' do
    status { :for }

    association :voter, factory: :user
    association :voteble, factory: :question

    trait :against do
      status { :against }
    end
  end

  factory :answer_vote, class: 'Vote' do
    status { :for }

    association :voter, factory: :user
    association :voteble, factory: :answer

    trait :against do
      status { :against }
    end
  end
end
