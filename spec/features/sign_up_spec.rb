require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  scenario 'registration completed successfully' do
    user = create(:user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  scenario 'registration failed'
end
