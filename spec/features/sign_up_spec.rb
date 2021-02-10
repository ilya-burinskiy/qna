require 'rails_helper'

feature 'User can sign up' do
  background { visit new_user_registration_path }

  scenario 'registration completed successfully' do
    fill_in 'Email', with: 'rndmail@mail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'email taken' do
    user = create(:user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'filled form with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
