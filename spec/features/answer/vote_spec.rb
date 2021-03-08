require 'rails_helper'

feature 'User can vote for an answer' do
  given!(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do
    context 'As another user' do
      background do
        sign_in(create(:user))
        visit question_path(answer.question)
      end

      scenario 'tries to vote for' do
        within "#vote-answer-#{answer.id}" do
          click_on 'For'
          within('.votable__rating') { expect(page).to have_content('1') }
        end
      end

      scenario 'tries to vote against' do
        within "#vote-answer-#{answer.id}" do
          click_on 'Against'
          within('.votable__rating') { expect(page).to have_content('-1') }
        end
      end

      scenario 'tries to unvote' do
        within "#vote-answer-#{answer.id}" do
          click_on 'For'
          click_on 'Unvote'
          within('.votable__rating') { expect(page).to have_content('0') }
        end
      end
    end

    context 'As answer author' do
      scenario 'tries to vote' do
        sign_in(answer.author)
        visit question_path(answer.question)

        within ".answers-list" do
          expect(page).to_not have_link 'For'
          expect(page).to_not have_link 'Unvote'
          expect(page).to_not have_link 'Against'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote' do
    visit question_path(answer.question)
  
    expect(page).to_not have_link 'For'
    expect(page).to_not have_link 'Unvote'
    expect(page).to_not have_link 'Against'
  end
end
