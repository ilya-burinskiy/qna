require 'rails_helper'
require Rails.root.join('spec/models/concerns/votable.rb')

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable'

  describe "#become_best" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answers) { create_list(:answer, 3, question: question, author: create(:user)) }

    it 'should make the answer to become best' do
      last_answer = question.answers.last
      last_answer.become_best

      expect(question.answers.first.best).to eq true
      expect(question.answers.first).to eq last_answer
    end

    it 'should make another answer to become best' do
      question.answers.last.become_best
      second_answer = question.answers.second
      second_answer.become_best
      
      expect(question.answers.where(best: true).count).to eq 1
      expect(question.answers.first.best).to eq true
      expect(question.answers.first).to eq second_answer
    end

    context 'Question has reward' do
      let!(:reward) { create(:reward, question: question, author: user) }

      it 'adds new reward to user' do
        expect { answers.last.become_best }.to change(answers.last.author.earned_rewards, :count).by(1)
      end
    end

    context 'Question does not have reward' do
      it 'does not add new reward to user' do
        expect { answers.last.become_best }.to_not change(answers.last.author.earned_rewards, :count)
      end
    end
  end
end
