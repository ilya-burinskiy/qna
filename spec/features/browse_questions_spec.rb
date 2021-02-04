require 'rails_helper'

feature 'User can browse questions' do
  given!(:question) { create(:question) }

  scenario 'any user can browse questions' do
    visit questions_path

    expect(page).to have_content question.title
  end
end
