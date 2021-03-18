require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'Guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  context 'Admin' do
    let(:user) { create(:admin) }
    it { should be_able_to :manage, :all }
  end

  context 'User' do
    let(:user) { create(:user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    context 'As resource author' do
      describe 'Question abilities' do
        let(:question) { create(:question, author: user) }

        it { should be_able_to :update, question }
        it { should be_able_to :destroy, question }

        context 'With link' do
          let(:link) { create(:link, :question, linkable: question) }

          it { should be_able_to :destroy, link }
        end

        context 'With attachment' do
          before do
            question.files.attach(io: File.open("#{Rails.root}/db/seeds.rb"), filename: 'seeds.rb')
          end
          
          it { should be_able_to :destroy, question.files.first }
        end
      end

      describe 'Answer abilities' do
        let(:answer) { create(:answer, author: user) }

        it { should be_able_to :update, answer }
        it { should be_able_to :destroy, answer }

        context 'With link' do
          let(:link) { create(:link, :answer, linkable: answer) }

          it { should be_able_to :destroy, link }
        end

        context 'With attachment' do
          before do
            answer.files.attach(io: File.open("#{Rails.root}/db/seeds.rb"), filename: 'seeds.rb')
          end
          
          it { should be_able_to :destroy, answer.files.first }
        end

        describe 'Best answer ability' do
          it { should_not be_able_to :best, answer }
        end

        describe 'Voting abilities' do
          it { should_not be_able_to :vote_for, answer }
          it { should_not be_able_to :vote_against, answer }
          it { should_not be_able_to :unvote, answer }
        end
      end
    end

    context 'As not resource author' do
      describe 'Question abilities' do
        let(:question) { create(:question) }

        it { should_not be_able_to :update, question }
        it { should_not be_able_to :destroy, question }

        context 'With link' do
          let(:link) { create(:link, :question, linkable: question) }

          it { should_not be_able_to :destroy, link }
        end

        context 'With attachment' do
          before do
            question.files.attach(io: File.open("#{Rails.root}/db/seeds.rb"), filename: 'seeds.rb')
          end
          
          it { should_not be_able_to :destroy, question.files.first }
        end
      end

      describe 'Answer abilities' do
        let(:answer) { create(:answer) }

        it { should_not be_able_to :update, answer }
        it { should_not be_able_to :destroy, answer }

        context 'With link' do
          let(:link) { create(:link, :answer, linkable: answer) }

          it { should_not be_able_to :destroy, link }
        end

        context 'With attachment' do
          before do
            answer.files.attach(io: File.open("#{Rails.root}/db/seeds.rb"), filename: 'seeds.rb')
          end
          
          it { should_not be_able_to :destroy, answer.files.first }
        end

        describe 'Best answer ability' do
          let(:user) { answer.question.author }
          
          it { should be_able_to :best, answer }
        end

        describe 'Voting abilities' do
          it { should be_able_to :vote_for, answer }
          it { should be_able_to :vote_against, answer }
          it { should be_able_to :unvote, answer }
        end
      end
    end
  end
end
