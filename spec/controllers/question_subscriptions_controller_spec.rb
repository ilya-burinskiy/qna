require 'rails_helper'

RSpec.describe QuestionSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(user) }

      it 'creates subscription' do
        expect do
          post :create, params: { question_id: question }, format: :js
        end.to change(user.subscribed_questions, :count).by(1)
      end
    end

    context 'Unauthenticated user' do
      it 'does not create subscription' do
        expect do
          post :create, params: { question_id: question }, format: :js
        end.to_not change(user.subscribed_questions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:question_subscription, user: user) }

    context 'Authenticated user' do
      before { login(user) }

      context 'Authenticated user is subscription author' do
        it 'deletes subscription' do
          expect do
            delete :destroy, params: { id: subscription }, format: :js
          end.to change(user.subscribed_questions, :count).by(-1)
        end
      end

      context 'Authenticated user is not subscription auhtor' do
        before { login(create(:user)) }

        it 'does not deletes subscription' do
          expect do
            delete :destroy, params: { id: subscription }, format: :js
          end.to_not change(user.subscribed_questions, :count)
        end

        it 'responses with 403 status' do
          delete :destroy, params: { id: subscription }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not deletes subscription' do
        expect do
          delete :destroy, params: { id: subscription }, format: :js
        end.to_not change(user.subscribed_questions, :count)
      end
    end
  end
end
