class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :voter, class_name: 'User', foreign_key: 'voter_id'

  validates :voter_id, uniqueness: { 
    scope: [:votable_type, :votable_id],
    message: "You have already voted"
  }
  validate :validate_vote_author

  private

  def validate_vote_author
    errors.add(:base, "Author cannot vote for his votables") if votable && voter == votable.author
  end
end
