require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, author: user1) }

  before do
    question.files.attach(io: File.open("#{Rails.root}/db/seeds.rb"), filename: 'seeds.rb')
  end

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      before { login(user1) }

      context 'as author' do
        it 'deletes attached file' do
          expect { delete :destroy, params: { id: question.files.first}, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders #destroy' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
  
      context 'as another user' do
        before { login(user2) }

        it 'does not delete file attached by another user' do
          expect { delete :destroy, params: { id: question.files.first}, format: :js }.to_not change(question.files, :count)
        end

        it 'redirects to root' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to redirect_to root_url
        end
      end
    end
  
    describe 'Unauthenticated user' do
      it 'can not delete attached file' do
        expect { delete :destroy, params: { id: question.files.first} }.to_not change(question.files, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, params: { id: question.files.first }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
