require 'rails_helper'

feature 'User can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/ilya-burinskiy/aa94bd7af515d1a1157745080902e1b9' }

  scenario 'User adds link when answering a question', js: true do
    sign_in(user)
    visit question_path(question)

    within 'form.new-answer' do
      fill_in 'Body', with: 'Body'

      click_on 'Add link'
      wait_for_ajax

      within all('.nested-fields')[0] do
        fill_in 'Link name', with: 'Gist1'
        fill_in 'Url', with: gist_url
      end

      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Gist2'
        fill_in 'Url', with: gist_url
      end

      click_on 'Answer the question'
    end

    within '.answers-list' do
      expect(page).to have_link 'Gist1', href: gist_url
      expect(page).to have_link 'Gist2', href: gist_url
    end
  end
end
