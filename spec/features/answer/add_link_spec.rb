require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/ilya-burinskiy/aa94bd7af515d1a1157745080902e1b9' }

  scenario 'User adds link when answering a question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Body'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Answer the question'

    within '.answers-list' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
