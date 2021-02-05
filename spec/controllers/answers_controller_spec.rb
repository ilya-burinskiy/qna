require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before { login(user) }

    describe 'GET #edit' do
      before { get :edit, params: { id: answer } }

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        end

        it 'redirects to questions#show' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
        end

        it 're-renders the questions#show' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          answer.reload

          expect(answer.body).to eq 'MyText'
        end

        it 'redirects to a questions#show' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

        it 'does not change the answer' do
          answer.reload

          expect(answer.body).to eq 'MyText'
        end

        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end
  end


  describe 'Unauthenticated user' do
    describe 'GET #edit' do
      before { get :edit, params: { id: answer } }

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(question.answers, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PATCH #update' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer) } }

      it 'does not change the answer' do
        answer.reload

        expect(answer.body).to eq 'MyText'
      end

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
