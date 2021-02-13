class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  def sorted_answers
    return answers if best_answer.nil?

    sorted_answers = answers.to_a
    best_answer_idx = sorted_answers.find_index(best_answer)
    sorted_answers[0], sorted_answers[best_answer_idx] = sorted_answers[best_answer_idx], sorted_answers[0]
    sorted_answers
  end
end
