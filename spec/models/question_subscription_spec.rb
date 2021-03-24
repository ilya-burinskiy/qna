require 'rails_helper'

RSpec.describe QuestionSubscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
 
  describe 'validation of uniqueness of user_id within question_id' do
    let!(:subscription) { create(:question_subscription) }
    let(:user) { subscription.user }
    let(:question) { subscription.question }

    it 'should raise RecordInvalid if such record already exists' do
      expect { create(:question_subscription, user: user, question: question) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
