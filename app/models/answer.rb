class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def become_best
    old_best_answer = question.best_answer

    Answer.transaction do
      old_best_answer.update!(best: false) if old_best_answer
      update!(best: true)
    end
  end
end
