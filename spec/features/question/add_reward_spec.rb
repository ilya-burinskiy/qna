require 'rails_helper'

feature 'User can add reward to question' do
  given(:user) { create(:user) }

  scenario 'User adds reward when creates question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    fill_in 'Reward name', with: 'Reward'
    attach_file 'Image', "#{Rails.root}/spec/fixtures/files/award_badge.png"
    click_on 'Ask'

    expect(Question.last.reward).to be_a(Reward)
  end
end
