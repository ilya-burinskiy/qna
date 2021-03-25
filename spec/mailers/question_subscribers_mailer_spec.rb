require "rails_helper"

RSpec.describe QuestionSubscribersMailer, type: :mailer do
  describe 'notify' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:mail) { QuestionSubscribersMailer.notify(user, question) }

    it 'sends message to user email' do
      expect(mail.to).to eq([user.email])
    end
  end
end
