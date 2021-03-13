require 'rails_helper'

feature 'User can edit question' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user1) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his question' do
      sign_in(user1)
      visit question_path(question)
      click_on 'Edit'
      
      fill_in 'Title', with: 'New title'
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to have_content 'New title'
    end

    scenario 'edits his question with errors' do
      sign_in(user1)
      visit question_path(question)
      click_on 'Edit'

      fill_in 'Title', with: ''
      click_on 'Save'

      expect(page).to have_selector 'textarea'
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits a question with attached file' do
      sign_in(user1)
      visit question_path(question)
      
      click_on 'Edit'
      within("form#edit-question-#{question.id}") do
        fill_in 'Title', with: 'Title'
        fill_in 'Body', with: 'Body'
        attach_file 'File', ["#{Rails.root}/db/seeds.rb", "#{Rails.root}/db/schema.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'seeds.rb'
      expect(page).to have_link 'schema.rb'
    end
  end
end
