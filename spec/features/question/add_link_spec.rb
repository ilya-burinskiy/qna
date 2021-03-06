require 'rails_helper'

feature 'User can add links to question', js: true do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/ilya-burinskiy/aa94bd7af515d1a1157745080902e1b9' }

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Title'
    fill_in 'Body', with: 'Body'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Ask'

    visit question_path(Question.last)
    expect(page).to have_content 'My gist'
  end
end
