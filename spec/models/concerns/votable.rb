require 'rails_helper'

shared_examples_for 'votable' do
  let(:votable_klass) { described_class.to_s.underscore.to_sym }
  let(:votable) { build(votable_klass) }
  let(:user) { create(:user) }

  describe '#for_count' do
    it 'should return number of for votes' do
      user.vote(votable, :for)
      expect(votable.for_count).to eq 1
    end
  end

  describe '#against_count' do
    it 'should return number of against votes' do
      user.vote(votable, :against)
      expect(votable.against_count).to eq 1
    end
  end

  describe '#rating' do
    let(:user2) { create(:user) }

    it 'should return votable rating' do
      user.vote(votable, :for)
      user2.vote(votable, :against)
      expect(votable.rating).to eq 0
    end
  end
end
