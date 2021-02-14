class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc) }

  def become_best
    if question.answers.where(best: true).count == 1
      old_best_answer = question.answers.first
      old_best_answer.best = false
      old_best_answer.save
    end

    self.best = true
    save
  end
end
