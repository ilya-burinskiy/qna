require 'rails_helper'

feature 'User can create answer on the question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'Body'
      click_on 'Answer the question'

      expect(page).to have_content 'Body'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question with attached files' do
      fill_in 'Body', with: 'Body'
      attach_file 'File', ["#{Rails.root}/db/seeds.rb", "#{Rails.root}/db/schema.rb"]
      click_on 'Answer the question'

      expect(page).to have_link 'seeds.rb'
      expect(page).to have_link 'schema.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer the question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
