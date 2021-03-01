require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user1) }
  let(:reward) { create(:reward, question: question, author: user1) }
  let(:answer) { create(:answer, author: user2) }

  describe 'GET #index' do
    context 'Authenticated user' do
      before(:each) do
        answer.become_best
      end

      it 'populates an array of all questions' do
        login(user2)
        get :index
        expect(assigns(:rewards)).to match_array(user2.earned_rewards)
      end

      it 'renders index view' do
        login(user2)
        get :index
        expect(response).to render_template :index
      end
    end

    context 'Unauthenticated user' do
      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
