require 'rails_helper'

shared_examples_for 'votable' do
  let(:votable_klass) { described_class.to_s.underscore.to_sym }
  let(:votable) { build(votable_klass) }
  let(:user) { create(:user) }

  describe '#user_vote' do
    it 'should return user vote' do
      vote = user.vote(votable, 1)
      expect(votable.user_vote(user)).to eq vote
    end
  end

  describe '#rating' do
    let(:user2) { create(:user) }

    it 'should return votable rating' do
      user.vote(votable, 1)
      user2.vote(votable, -1)
      expect(votable.rating).to eq 0
    end
  end
end
