class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true

  def author?(user)
    return false if user.nil?

    user.answers.include?(self)
  end
end
