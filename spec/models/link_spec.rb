require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#validate_link_url' do
    context 'valid url' do
      let(:valid_question_link) { build(:question_link) }
      it 'does not add new error message' do
        expect { valid_question_link.save }.to_not change(valid_question_link.errors, :count)
      end
    end

    context 'invalid url' do
      let(:invalid_question_link) { build(:question_link, :invalid) }
      it 'adds new error message' do
        expect { invalid_question_link.save }.to change(invalid_question_link.errors, :count).by(1)
      end
    end
  end
end
