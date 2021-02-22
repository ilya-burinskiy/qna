class Link < ApplicationRecord
  belongs_to :question

  validates :name, presence: true
  validates :url, presence: true
end
