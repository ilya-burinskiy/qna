FactoryBot.define do
  factory :question_link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/p" }
    association :linkable, factory: :question
  end

  factory :answer_link, class: "Link" do
    name { "Google" }
    url { "https://www.google.com/p" }
    association :linkable, factory: :answer
  end
end
