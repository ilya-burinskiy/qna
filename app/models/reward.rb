class Reward < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  belongs_to :question

  has_one_attached :image

  validates :name, presence: true
end
