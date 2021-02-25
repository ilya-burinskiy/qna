require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, author: user1) }
  let!(:question_link) { create(:question_link, linkable: question) }

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      context 'as author' do
        before { login(user1) }

        it 'deletes link' do
          expect { delete :destroy, params: { id: question_link }, format: :js }.to change(question.links, :count).by(-1)
        end

        it 'renders #destroy' do
          delete :destroy, params: { id: question_link }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as another user' do
        before { login(user2) }

        it 'does not delete another user link' do
          expect { delete :destroy, params: { id: question_link }, format: :js }.to_not change(question.links, :count)
        end

        it 'renders #destroy' do
          delete :destroy, params: { id: question_link }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    it 'can not delete link' do
      expect { delete :destroy, params: { id: question_link }, format: :js }.to_not change(question.links, :count)
    end

    it 'responses with unauthorized status' do
      delete :destroy, params: { id: question_link }, format: :js
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
