require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask new question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Body'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Title'
      expect(page).to have_content 'Body'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end


  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask new question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
