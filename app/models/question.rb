class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :answers, dependent: :destroy
  has_one_attached :file

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.where(best: true).first
  end
end
