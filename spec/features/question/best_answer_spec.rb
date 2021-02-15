require 'rails_helper'

feature 'The author of the question can choose the best answer' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user1) }
  given!(:answers) { create_list(:answer, 3, question: question, author: create(:user)) }

  scenario 'Unauthenticated user can not choose best answer to the question' do
    visit question_path(question)

    answers.each do |answer|
      expect(find_by_id("answers-list__#{answer.id}")).to_not have_link 'Best'
    end
  end

  describe 'Authenticated user', js: true do
    scenario 'as question author has choosed best answer to his question' do
      sign_in(user1)
      visit question_path(question)

      answers.each do |answer|
        expect(find_by_id("answers-list__#{answer.id}")).to have_link 'Best'
      end

      first_answer = answers[0]
      best_answer = answers[1]

      find_by_id("answers-list__#{best_answer.id}").click_on 'Best'

      expect(find('.answers-list').all('li')[0].text).to have_content best_answer.body
      expect(find('.answers-list').all('li')[1].text).to have_content first_answer.body
    end

    scenario "can not choose best answer to another author's question" do
      sign_in(user2)
      visit question_path(question)

      answers.each do |answer|
        expect(find_by_id("answers-list__#{answer.id}")).to_not have_link 'Best'
      end
    end
  end
end
