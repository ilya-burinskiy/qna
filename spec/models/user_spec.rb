require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  
  it { should have_many(:created_rewards).dependent(:destroy) }
  it { should have_many(:user_rewards).dependent(:destroy) }
  it { should have_many(:earned_rewards).through(:user_rewards).source(:reward) }

  it { should have_many(:question_subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:question_subscriptions).source(:question) }

  it { should have_many(:votes).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user1) }

  describe ".all_except" do
    let!(:users) { create_list(:user, 3) }
    let!(:user) { create(:user) }

    it 'should return users' do
      expect(User.all_except(user)).to eq users
    end
  end

  describe '#author?' do
    it 'should be author of question' do
      expect(user1).to be_author(question)
    end

    it 'should not be author of question' do
      expect(user2).to_not be_author(question)
    end
  end

  describe '#subscribed?' do
    let(:subscription) { create(:question_subscription) }

    context 'User has subscribed for the question' do
      let(:user) { subscription.user }
      let(:question) { subscription.question }

      it 'should return true' do
        expect(user.subscribed?(question)).to be_truthy
      end
    end

    context 'Use has not subscribed for the question' do
      let(:user) { create(:user) }

      it 'should return false' do
        expect(user.subscribed?(question)).to be_falsey
      end
    end
  end

  describe '#vote' do
    context 'User is votable author' do
      it 'should not change user assigned votes count' do
        expect { user1.vote(question, 1) }.to_not change(user1.votes, :count)
      end

      it 'should add error to user vote' do
        vote = user1.vote(question, :for)
        expect(vote.errors.full_messages).to include("Author cannot vote for his votables")
      end
    end

    context 'User votes for the first time' do
      it 'should change by 1 user assigned votes count' do
        expect { user2.vote(question, 1) }.to change(user2.votes, :count).by(1)
      end
    end

    context 'User votes twice' do
      before { user2.vote(question, 1) }

      it 'should not change user assigned votes count' do
        expect { user2.vote(question, -1) }.to_not change(user2.votes, :count)
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
        expect { user2.unvote(question) }.to change(user2.votes, :count).by(-1)
      end
    end

    context 'User has not voted' do
      it 'shoud not change Vote count' do
        expect { user2.unvote(question) }.to_not change(Vote, :count)
      end
    end
  end

  describe '#subscribe_for_question' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'User has not yet subscribed for question' do
      it 'creates new subscription' do
        expect do
          user.subscribe_for_question(question)
        end.to change(user.question_subscriptions, :count).by(1)
      end
    end

    context 'User has subscribed for question' do
      let!(:question_subscription) { create(:question_subscription, user: user, question: question) }

      it 'does not create subscription' do
        expect do
          user.subscribe_for_question(question)
        end.to_not change(user.question_subscriptions, :count)
      end
    end
  end

  describe '#unsubscribe_from_question' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    
    context 'User has not yet subscribed for question' do
      let!(:question_subscription) { create(:question_subscription, user: user) }

      it 'do nothing' do
        expect do
          user.unsubscribe_from_question(question)
        end.to_not change(user.question_subscriptions, :count)
      end
    end

    context 'User has subscribed for question' do
      let!(:new_question_subscription) { create(:question_subscription, user: user, question: question) }

      it 'deletes subscription' do
        expect do
          user.unsubscribe_from_question(question)
        end.to change(user.question_subscriptions, :count).by(-1)
      end
    end
  end

  describe '#admin?' do
    let(:admin) { create(:admin) }
    
    it 'should return true if user is admin' do
      expect(admin).to be_admin
    end
  end
end
