require 'rails_helper'

feature 'User can vote for a question' do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    context 'As another user' do
      background do
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario 'tries to vote for' do
        within "#vote-question-#{question.id}" do
          click_on 'For'
          within('.votable__rating') { expect(page).to have_content('1') }
        end
      end

      scenario 'tries to vote against' do
        within "#vote-question-#{question.id}" do
          click_on 'Against'
          within('.votable__rating') { expect(page).to have_content('-1') }
        end
      end

      scenario 'tries to unvote' do
        within "#vote-question-#{question.id}" do
          click_on 'For'
          click_on 'Unvote'
          within('.votable__rating') { expect(page).to have_content('0') }
        end
      end
    end

    context 'As question author' do
      scenario 'tries to vote' do
        sign_in(question.author)
        visit question_path(question)

        expect(page).to_not have_link 'For'
        expect(page).to_not have_link 'Unvote'
        expect(page).to_not have_link 'Against'
      end
    end
  end

  scenario 'Unauthenticated user tries to vote' do
    visit question_path(question)
  
    expect(page).to_not have_link 'For'
    expect(page).to_not have_link 'Unvote'
    expect(page).to_not have_link 'Against'
  end
end
