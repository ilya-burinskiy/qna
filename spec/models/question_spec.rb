require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should belong_to(:best_answer).optional }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#sorted_answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answers) { create_list(:answer, 3, question: question, author: user) }

    it 'should swap first answer with best answer' do 
      question.best_answer = answers.last

      expect(question.sorted_answers.first).to eq question.best_answer
      expect(question.sorted_answers.last).to eq question.answers.first
    end
  end
end
