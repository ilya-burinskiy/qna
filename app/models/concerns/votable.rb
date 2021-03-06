module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def for_count
    votes.where(status: Vote.statuses[:for]).count
  end

  def against_count
    votes.where(status: Vote.statuses[:against]).count
  end

  def rating
    for_count - against_count
  end
end
