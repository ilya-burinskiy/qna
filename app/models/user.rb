class User < ApplicationRecord
  has_many :answers, class_name: "Answer", foreign_key: "author_id", dependent: :destroy
  has_many :questions, class_name: "Question", foreign_key: "author_id", dependent: :destroy
  has_many :created_rewards, class_name: "Reward", foreign_key: "author_id", dependent: :destroy
  has_many :user_rewards, dependent: :destroy
  has_many :earned_rewards, through: :user_rewards, source: :reward
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author?(resource)
    resource.author_id == id
  end
end
