require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_one(:best_to_question).dependent(:nullify) }
  it { should belong_to(:author) }

  it { should validate_presence_of :body }
end
