require 'rails_helper'

RSpec.describe QuestionSubscribersNotifiactionJob, type: :job do
  let(:question) { create(:question) }
  let(:service) { QuestionSubscribersNotifier }

  it 'calls QuestionSubscribersNotifier.call' do
    expect(service).to receive(:call).with(question)
    QuestionSubscribersNotifiactionJob.perform_now(question)
  end
end
