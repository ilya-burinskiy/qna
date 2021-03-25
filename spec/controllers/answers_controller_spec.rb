require 'rails_helper'
require Rails.root.join('spec/controllers/concerns/voted.rb')

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  it_behaves_like 'voted'

  describe 'Authenticated user' do
    before { login(user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'renders the create' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
        end

        it 'renders the create' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
        end
      end
    end

    describe 'PATCH #update' do
      context "Logged user is answer author" do
        context 'with valid attributes' do
          it 'assigns the requested answer to @answer' do
            patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js

            expect(assigns(:answer)).to eq answer
          end

          it 'changes answer attributes' do
            new_answer_attribures = attributes_for(:answer)
            patch :update, params: { id: answer, answer: new_answer_attribures }, format: :js
            answer.reload

            expect(answer.body).to eq new_answer_attribures[:body]
          end

          it 'renders #update' do
            patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change the answer' do
            old_answer = answer
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            answer.reload

            expect(answer.body).to eq old_answer.body
          end

          it 'renders update' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end
      end

      context "Logged user is not answer author" do
        before { login(create(:user)) }

        it 'does not changes answer attributes' do
          old_answer = answer
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          answer.reload

          expect(answer).to eq old_answer
        end

        it 'responses with 403' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'PATCH #best_answer' do
      context 'Logged user is question author' do
        it 'answer becomes the best for the question' do
          patch :best, params: { id: answer }, format: :js
          question.reload

          expect(question.best_answer).to eq answer
        end

        it 'renders #answer' do
          patch :best, params: { id: answer }, format: :js
          expect(response).to render_template :best
        end
      end

      context 'Logged user is not question author' do
        before { login(create(:user)) }

        it 'answer does not become the best for the question' do
          patch :best, params: { id: answer }, format: :js
          question.reload
          
          expect(question.best_answer).to eq nil
        end

        it 'responses with 403' do
          patch :best, params: { id: answer }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'deletes the answer if current user is its author' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'does not delete the answer if current user is not its author' do
        login(create(:user))
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(question.answers, :count)
      end

      it 'renders #destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end


  describe 'Unauthenticated user' do
    describe 'POST #create' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'responses with unauthorized status' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH #update' do
      it 'does not change the answer' do
        old_answer = answer
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload

        expect(answer.body).to eq old_answer.body
      end

      it 'responses with unauthorized status' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH #best_answer' do
      it 'answer does not become the best for question' do
        patch :best, params: { id: answer }, format: :js
        question.reload

        expect(question.best_answer).to eq nil
      end
    end

    describe 'DELETE #destroy' do
      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(question.answers, :count)
      end

      it 'responses with unauthorized status' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
