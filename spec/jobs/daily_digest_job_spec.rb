require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { DailyDigestService }

  it 'calls DailyDigest#call' do
    expect(service).to receive(:call)
    DailyDigestJob.perform_now
  end
end
