class User < ApplicationRecord
  has_many :answers, class_name: "Answer", foreign_key: "author_id", dependent: :destroy
  has_many :questions, class_name: "Question", foreign_key: "author_id", dependent: :destroy
  has_many :created_rewards, class_name: "Reward", foreign_key: "author_id", dependent: :destroy
  has_many :user_rewards, dependent: :destroy
  has_many :earned_rewards, through: :user_rewards, source: :reward

  has_many :assigned_votes, class_name: "Vote", foreign_key: "voter_id", dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    resource.author_id == id
  end

  def vote(votable, vote_status)
    Vote.create(voter: self, votable: votable, status: vote_status)
  end

  def unvote(votable)
    get_vote(votable).destroy if get_vote(votable)
  end

  def get_vote(votable)
    @vote ||= assigned_votes.where(votable: votable).first
  end
end
