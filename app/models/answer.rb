class Answer < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  has_many :comments, dependent: :destroy, as: :commentable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def become_best
    old_best_answer = question.best_answer
    reward = question.reward

    if old_best_answer.nil?
      Answer.transaction do
        update!(best: true)
        UserReward.create(reward: reward, user: author) if reward
      end
    elsif old_best_answer.id != id
      Answer.transaction do
        old_best_answer.update!(best: false)
        update!(best: true)
        UserReward.create(reward: reward, user: author) if reward
      end
    end

  end
end
