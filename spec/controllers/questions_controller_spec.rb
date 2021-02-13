require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3, author: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'Authenticated user' do
    before { login(user) }

    describe 'GET #new' do
      before { get :new }

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to a show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      context 'Logged user is question author' do
        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            new_question_attributes = attributes_for(:question)
            patch :update, params: { id: question, question: new_question_attributes, format: :js }
            question.reload

            expect(question.title).to eq new_question_attributes[:title]
            expect(question.body).to eq new_question_attributes[:body]
          end

          it 'renders #update' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          it 'does not change the question' do
            old_question = question
            patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
            question.reload

            expect(question.title).to eq old_question.title
            expect(question.body).to eq old_question.body
          end

          it 'renders #update' do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
            expect(response).to render_template :update
          end
        end
      end

      context 'Logged user is not question author' do
        it 'does not changes question attributes' do
          old_question = question
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          question.reload

          expect(question).to eq old_question
        end

        it 'renders #update' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    describe 'PATCH #best_answer' do
      let(:answer) { create(:answer, question: question, author: create(:user)) }
      
      context 'Logged user is question author' do
        it 'answer becomes the best for the question' do
          patch :best_answer, params: { id: question, answer_id: answer, format: :js }
          question.reload

          expect(question.best_answer).to eq answer
        end

        it 'renders #best_answer' do
          patch :best_answer, params: { id: question, answer_id: answer, format: :js }
          expect(response).to render_template :best_answer
        end
      end

      context 'Logged user is not question author' do
        before { login(create(:user)) }

        it 'answer does not become the best for the question' do
          patch :best_answer, params: { id: question, answer_id: answer, format: :js }
          question.reload

          expect(question.best_answer).to eq nil
        end

        it 'renders #best_answer' do
          patch :best_answer, params: { id: question, answer_id: answer, format: :js }
          expect(response).to render_template :best_answer
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:question) { create(:question, author: user) }

      it 'deletes the question if current user is its author' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'does not delete the question if current use is not its author' do
        another_user = create(:user)
        login(another_user)
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
      
      it 'redirects to #index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  describe 'Unauthenticated user' do
    describe 'GET #new' do
      before { get :new }

      it 'redirects to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PATCH #update' do
      it 'does not change the question' do
        old_question = question
        patch :update, params: { id: question, question: attributes_for(:question) }
        question.reload

        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end

      it 'redirects to sign in page' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PATCH #best_answer' do
      let(:answer) { create(:answer, question: question, author: create(:user)) }
      
      it 'answer does not become the best for question' do
        patch :best_answer, params: { id: question, answer_id: answer, format: :js }
        question.reload

        expect(question.best_answer).to eq nil
      end
    end

    describe 'DELETE #destroy' do
      let!(:question) { create(:question) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
      
      it 'redirects to sign in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
