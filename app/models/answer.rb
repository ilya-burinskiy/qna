class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question
  has_one :best_to_question, class_name: 'Question', foreign_key: 'best_answer_id', dependent: :nullify

  validates :body, presence: true
end
