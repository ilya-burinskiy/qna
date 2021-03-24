class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy
  
  has_many :comments, dependent: :destroy, as: :commentable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true

  def best_answer
    answers.where(best: true).first
  end

  def self.asked_today
    Question.where(created_at: Time.current.all_day)
  end
end
