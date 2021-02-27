FactoryBot.define do
  factory :question_link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/" }
    association :linkable, factory: :question

    trait :invalid do
      url { "htps://www.google.com" }
    end

    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/ilya-burinskiy/aa94bd7af515d1a1157745080902e1b9" }
    end
  end

  factory :answer_link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/" }
    association :linkable, factory: :answer
    
    trait :invalid do
      url { "htps://www.google.com" }
    end

    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/ilya-burinskiy/aa94bd7af515d1a1157745080902e1b9" }
    end
  end
end
