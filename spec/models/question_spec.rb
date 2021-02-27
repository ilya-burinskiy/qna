require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has one attached file' do
    expect(Question.new.files).to be_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#best_answer' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answers) { create_list(:answer, 3, question: question, author: create(:user)) }

    it 'should return nil if there is no best answer' do
      expect(question.best_answer).to eq nil
    end

    it "should return question's best answer" do
      last_answer = answers.last
      last_answer.become_best

      expect(question.best_answer).to eq last_answer
    end
  end
end
