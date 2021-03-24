require 'rails_helper'
require Rails.root.join('spec/models/concerns/votable.rb')

RSpec.describe Question, type: :model do
  it { should belong_to(:author) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable'

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

  describe '.asked_today' do
    let!(:questions) { create_list(:question, 3) }

    context 'if there are questions created today' do
      it 'returns questions created today' do
        expect(Question.asked_today).to match_array(questions)
      end
    end

    context 'if there are no questions created today' do
      before do
        questions.each do |question|
          question.update(created_at: question.created_at + 1.day)
        end
      end

      it 'returns empty relation' do
        expect(Question.asked_today).to match_array([])
      end
    end
  end
end
