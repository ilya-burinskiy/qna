require 'rails_helper'

feature 'User can view the question and answers to it' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }
  given!(:answers) { create_list(:answer, 3, question: question, author: create(:user)) }

  scenario 'user views all question answers' do
    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
