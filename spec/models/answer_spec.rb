require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }

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
  end
end
