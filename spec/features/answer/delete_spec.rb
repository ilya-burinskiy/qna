require 'rails_helper'

feature 'User can delete his answer' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }
  given!(:answer) { create(:answer, question: question, author: user1) }

  scenario 'user as the author of the answer deletes it' do
    sign_in(user1)
    visit question_path(question)
    expect(page).to have_content answer.body

    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end

  scenario 'user cannot delete a answer created by another user' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end

  scenario 'unauthenticated user can not delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
