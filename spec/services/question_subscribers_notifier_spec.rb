require 'rails_helper'

RSpec.describe QuestionSubscribersNotifier do
  let(:users) { create_list(:user, 3) }
  let!(:question) { create(:question, author: users.first) }

  before do
    users.each do |user|
      create(:question_subscription, user: user, question: question)
    end
  end

  it 'sends notification to all question subscribers' do
    users.each do |user|
      expect(QuestionSubscribersMailer).to receive(:notify).with(user, question).and_call_original
    end
    QuestionSubscribersNotifier.call(question)
  end
end
