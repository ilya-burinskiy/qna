require 'rails_helper'

feature 'User can create answer on the question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'Body'
      click_on 'Answer the question'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Body'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer the question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
