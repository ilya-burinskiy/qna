FactoryBot.define do
  factory :question_link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/p" }
    association :linkable, factory: :question

    trait :invalid do
      url { "htps://www.google.com" }
    end
  end

  factory :answer_link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/p" }
    association :linkable, factory: :answer
    
    trait :invalid do
      url { "htps://www.google.com" }
    end
  end
end
