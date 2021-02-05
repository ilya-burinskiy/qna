require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create(:user) }

  scenario 'user signs out' do
    sign_in(user)
    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
  end
end
