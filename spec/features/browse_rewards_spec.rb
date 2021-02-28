require 'rails_helper'

feature 'User can browse his rewards' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }
  given!(:reward) { create(:reward, question: question, author: question.author) }
  given!(:answer) { create(:answer, question: question, author: user) }

  before do
    answer.become_best
  end

  scenario 'User can view his rewards' do
    sign_in(user)
    visit rewards_path
    expect(page).to have_content reward.name
  end
end
