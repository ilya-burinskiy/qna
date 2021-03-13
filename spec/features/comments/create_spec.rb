require 'rails_helper'

feature 'User can add comment to question', js: true do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment' do
      within "#question-#{question.id}" do
        fill_in 'Comment', with: 'New comment'
        click_on 'Add comment'

        expect(page).to have_content 'New comment'
      end
    end

    scenario 'creates comment with errors' do
      within "#question-#{question.id}" do
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add comment' do
      visit question_path(question)
      within "#question-#{question.id}" do
        expect(page).to_not have_link "Add comment"
      end
    end
  end
end

feature 'User can add comment to answer', js: true do
  given!(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(answer.author)
      visit question_path(answer.question)
    end

    scenario 'creates comment' do
      within "#answers-list__#{answer.id}" do
        fill_in 'Comment', with: "New comment"
        click_on 'Add comment'

        expect(page).to have_content "New comment"
      end
    end

    scenario 'creates comment with errors' do
      within "#answers-list__#{answer.id}" do
        click_on 'Add comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not add comment' do
      visit question_path(answer.question)
      within "#answers-list__#{answer.id}" do
        expect(page).to_not have_link "Add comment"
      end
    end
  end
end
