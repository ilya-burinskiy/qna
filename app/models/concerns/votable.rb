module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def user_vote(user)
    votes.where(voter: user).first
  end

  def for_count
    votes.where(status: :for).count
  end

  def against_count
    votes.where(status: :against).count
  end

  def rating
    for_count - against_count
  end
end
