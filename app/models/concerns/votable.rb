module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def user_vote(user)
    votes.where(voter: user).first
  end

  def rating
    votes.sum(:status)
  end
end
