require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment) { create(:comment, :question) }
  let(:user) { create(:user) }

  describe '#POST #create' do
    let(:question) { create(:question) }

    context 'Authenticated user' do
      before { login(user) }

      context 'With valid attributes' do
        it 'finds commentable' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(assigns(:commentable)).to eq question
        end

        it 'saves a new comment in the database' do
          expect do
            post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          end.to change(question.comments, :count).by(1)
        end

        it 'renders #create' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'With invalid attributes' do
        it 'finds commentable' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          expect(assigns(:commentable)).to eq question
        end

        it 'does not save a new comment in the database' do
          expect do
            post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          end.to_not change(question.comments, :count)
        end

        it 'renders #create' do
          post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not save a new comment in the database' do
        expect do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        end.to_not change(Comment, :count)
      end

      it 'responses with unauthorized status' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
