class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def become_best
    old_best_answer = question.best_answer

    if old_best_answer.nil?
      update!(best: true)
    elsif old_best_answer.id != id
      Answer.transaction do
        old_best_answer.update!(best: false)
        update!(best: true)
      end
    end
  end
end
