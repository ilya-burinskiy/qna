FactoryBot.define do
  factory :reward do
    name { "Reward" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/award_badge.png", 'image/png') }
    
    association :question
    association :author, factory: :user
  end
end
