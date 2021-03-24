require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let!(:questions) { create_list(:question, 3) }

    it 'sends to mail to user email' do
      expect(mail.to).to eq([user.email])
    end

    it 'populates array of new questions' do
      mailer = described_class.new.tap do |mailer|
        mailer.process(:digest, user)
      end

      expect(mailer.instance_variable_get(:@new_questions)).to match_array(questions)
    end
  end
end
