require 'rails_helper'

feature 'User can view the question and answers to it' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }
  given!(:answer) { create(:answer, question: question, author: create(:user)) }

  scenario 'user views all question answers' do
    visit question_path(question)
    expect(page).to have_content answer.body
  end
end
