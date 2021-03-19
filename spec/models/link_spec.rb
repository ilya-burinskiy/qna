require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#validate_link_url' do
    context 'valid url' do
      let(:valid_question_link) { build(:link, :question) }
      it 'does not add new error message' do
        expect { valid_question_link.save }.to_not change(valid_question_link.errors, :count)
      end
    end

    context 'invalid url' do
      let(:invalid_question_link) { build(:link, :question, :invalid) }
      it 'adds new error message' do
        expect { invalid_question_link.save }.to change(invalid_question_link.errors, :count).by(1)
      end
    end
  end

  describe '#gist?' do
    context 'gist url' do
      let(:question_gist_url) { create(:link, :question, :gist) }

      it 'should return true' do
        expect(question_gist_url.gist?).to eq true
      end
    end

    context 'not gist url' do
      let(:question_url) { create(:link, :question) }

      it 'should return false' do
        expect(question_url.gist?).to eq false
      end
    end
  end
end
