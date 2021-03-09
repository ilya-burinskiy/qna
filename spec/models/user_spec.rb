require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:created_rewards).dependent(:destroy) }
  it { should have_many(:user_rewards).dependent(:destroy) }
  it { should have_many(:earned_rewards).through(:user_rewards).source(:reward) }
  it { should have_many(:assigned_votes).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user1) }

  describe '#author?' do
    it 'should be author of question' do
      expect(user1).to be_author(question)
    end

    it 'should not be author of question' do
      expect(user2).to_not be_author(question)
    end
  end

  describe '#vote' do
    context 'User is votable author' do
      it 'should not change user assigned votes count' do
        expect { user1.vote(question, 1) }.to_not change(user1.assigned_votes, :count)
      end

      it 'should add error to user vote' do
        vote = user1.vote(question, :for)
        expect(vote.errors.full_messages).to include("Author cannot vote for his votables")
      end
    end

    context 'User votes for the first time' do
      it 'should change by 1 user assigned votes count' do
        expect { user2.vote(question, 1) }.to change(user2.assigned_votes, :count).by(1)
      end
    end

    context 'User votes twice' do
      before { user2.vote(question, 1) }

      it 'should not change user assigned votes count' do
        expect { user2.vote(question, -1) }.to_not change(user2.assigned_votes, :count)
      end

      it 'should add error to user vote' do
        vote = user2.vote(question, 1)
        expect(vote.errors.messages[:voter_id]).to include("You have already voted")
      end
    end
  end

  describe '#unvote' do
    context 'User has voted' do
      it 'should delete his vot' do
        user2.vote(question, 1)
        expect { user2.unvote(question) }.to change(user2.assigned_votes, :count).by(-1)
      end
    end

    context 'User has not voted' do
      it 'shoud not change Vote count' do
        expect { user2.unvote(question) }.to_not change(Vote, :count)
      end
    end
  end
end
