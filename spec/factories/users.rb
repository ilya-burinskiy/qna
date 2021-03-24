FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { '123456' }
    password_confirmation { '123456' }
    type { 'User' }
  end
end
