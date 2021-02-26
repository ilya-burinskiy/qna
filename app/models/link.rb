require 'uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true
  validate :url, :validate_link_url

  private

  def validate_link_url
    begin
      valid = (URI.parse(url).scheme =~ /https?/)
    rescue URI::InvalidURIError
      valid = false
    end
    
    errors.add(:base, "Not a valid URL") unless valid
  end
end
