require 'rails_helper'

feature 'User can subscribe/unsubscribe for/from a question', js: true do
  given!(:question) { create(:question) }

  context 'Authenticated user' do
    let(:user) { create(:user) }

    context 'if has not subscribed' do
      scenario 'as not question author can subscribe to a question' do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'

        click_on 'Subscribe'

        expect(page).to_not have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end

    context 'if has subscribed' do
      scenario 'can unsubscribe' do
        subscription = create(:question_subscription, user: user, question: question)
        sign_in(user)
        visit question_path(question)

        expect(page).to have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'

        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end

    scenario 'as question author has already subscribed' do
      subscription = create(:question_subscription, user: question.author, question: question)
      sign_in(question.author)
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'

      click_on 'Unsubscribe'
      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  context 'Unauthenticated' do
    scenario 'can not subscribe to a question' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end
