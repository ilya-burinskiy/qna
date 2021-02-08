require 'rails_helper'

RSpec.describe User, type: :model do
  it { have_many(:answers).dependent(:destroy) }
  it { have_many(:questions).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User #author?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, author: user1) }
    let(:answer) { create(:answer, question: question, author: user1) }

    it 'should be author of answer and question' do
      expect(user1.author?(answer)).to eq true
      expect(user1.author?(question)).to eq true
    end

    it 'should not be author of answer and question' do
      expect(user2.author?(answer)).to eq false
      expect(user2.author?(question)).to eq false
    end
  end
end
