require 'uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true
  validate :url, :validate_link_url

  def gist?
    parsed_url = URI.parse(url)
    parsed_url.host == 'gist.github.com' && (parsed_url.path =~ /\/[a-zA-Z0-9_-]+\/\w+/) == 0
  end

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
