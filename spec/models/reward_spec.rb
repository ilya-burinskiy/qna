require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:author) }
  it { should belong_to(:question) }

  it { should validate_presence_of :name }

  it 'has one attached image' do
    expect(Reward.new.image).to be_instance_of(ActiveStorage::Attached::One)
  end
end
