require 'rails_helper'

feature 'User can delete his answer link', js: true do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user1) }
  given(:answer) { create(:answer, question: question, author: user1) }
  given!(:answer_link) { create(:answer_link, linkable: answer) }

  scenario 'user as the author of the link deletes it' do
    sign_in(user1)
    visit question_path(question)

    expect(page).to have_content answer_link.name

    click_on 'Delete link'

    expect(page).to_not have_content answer_link.name
  end

  scenario 'user can not delete a link created by another user' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end

  scenario 'unauthenticated user can not delete link' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete link'
  end
end
