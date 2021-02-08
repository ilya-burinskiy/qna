require 'rails_helper'

feature 'User can delete his question' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user1) }

  scenario 'user as the author of the answer deletes it' do
    sign_in(user1)
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    click_on 'Delete'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'user cannot delete a question created by another user' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'unauthenticated user can not delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
