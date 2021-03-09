require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: create(:user)) }

  it { should belong_to(:votable) }

  describe 'validation of uniqueness of voter_id within votable_type and votable_id' do
    let!(:vote1) { Vote.create(voter: user, votable: question, status: 1) }
    let(:vote2) { Vote.new(voter: user, votable: question, status: 1) }

    it 'should raise RecordInvalid if such record already exists' do
      expect { vote2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#validate_vote_author' do
    context 'User votes for his votable' do
      let(:vote) { Vote.new(voter: question.author, votable: question, status: 1) }

      it 'should raise RecordInvalid' do
        expect { vote.save! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'User votes for another votable' do
      let(:vote) { Vote.new(voter: user, votable: question, status: 1) }

      it 'should not raise error' do
        expect { vote.save! }.to_not raise_error
      end
    end
  end
end
