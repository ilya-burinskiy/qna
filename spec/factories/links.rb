FactoryBot.define do
  factory :link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/" }

    trait :question do
      association :linkable, factory: :question
    end

    trait :answer do
      association :linkable, factory: :answer
    end

    trait :gist do
      name { "Gist" }
      url { "https://gist.github.com/ilya-burinskiy/aa94bd7af515d1a1157745080902e1b9" }
    end

    trait :invalid do
      url { "htps://www.google.com" }
    end
  end
end
