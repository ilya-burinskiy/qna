require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:created_rewards).class_name("Reward").dependent(:destroy) }
  it { should have_many(:user_rewards).dependent(:destroy) }
  it { should have_many(:earned_rewards).through(:user_rewards).source(:reward) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user1) }

    it 'should be author of question' do
      expect(user1).to be_author(question)
    end

    it 'should not be author of question' do
      expect(user2).to_not be_author(question)
    end
  end
end
