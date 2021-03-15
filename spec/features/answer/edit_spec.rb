require 'rails_helper'

feature 'User can edit answer' do
  given!(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }
  given!(:answer) { create(:answer, question: question, author: user1) }

  scenario 'Unathenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer' do
      sign_in(user1)
      visit question_path(question)
      
      click_on 'Edit'

      within '.answers-list' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'edits his answer with errors' do
      sign_in(user1)
      visit question_path(question)

      click_on 'Edit'

      within '.answers-list' do
        fill_in 'Body', with: ''

        click_on 'Save'

        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits an answer with attached files' do
      sign_in(user1)
      visit question_path(question)

      within(".answers-list") do
        click_on 'Edit'
        fill_in 'Body', with: 'Body'
        attach_file 'File', ["#{Rails.root}/db/seeds.rb", "#{Rails.root}/db/schema.rb"]
        click_on 'Save'

        expect(page).to have_link 'seeds.rb'
        expect(page).to have_link 'schema.rb'
      end
    end
  end
end
