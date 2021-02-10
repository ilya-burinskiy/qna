require 'rails_helper'

feature 'User can browse questions' do
  given!(:questions) { create_list(:question, 3) }

  scenario 'any user can browse questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
