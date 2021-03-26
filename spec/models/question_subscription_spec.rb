require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  let!(:subscription) { create(:question_subscription) }

  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:question_id).with_message("already subscribed") }
end
