require 'rails_helper'

RSpec.describe User, type: :model do
  it { have_many(:answers).dependent(:destroy) }
  it { have_many(:questions).dependent(:destroy) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
end
