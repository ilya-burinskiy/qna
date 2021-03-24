require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Linkable' do
      let(:linkable) { question }
      let(:linkable_klass) { :question }
      let(:linkable_response) { json['question'] }
    end
    
    it_behaves_like 'API Commentable' do
      let(:commentable) { question }
      let(:commentable_klass) { :question }
      let(:commentable_response) { json['question'] }
    end

    it_behaves_like 'API Attachable' do
      let(:attachable) { question }
      let(:attachable_response) { json['question'] }
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions" }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      
      context 'With valid attributes' do
        it 'saves a new question in the database' do
          expect do
            do_request(
              method,
              api_path,
              params: {
                access_token: access_token.token,
                question: attributes_for(:question)
              },
              headers: headers
            )

          end.to change(Question, :count).by(1)
        end

        it 'has 200 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: access_token.token,
              question: attributes_for(:question)
            },
            headers: headers
          )

          expect(response).to be_successful
        end

        it 'returns public fields' do
          do_request(
            method,
            api_path,
            params: {
              access_token: access_token.token,
              question: attributes_for(:question)
            },
            headers: headers
          )

          %w[id title body created_at updated_at].each do |attr|
            expect(question_response[attr]).to eq assigns(:question).send(attr).as_json
          end
        end
      end

      context 'With invalid attributes' do
        it 'does not save question in the database' do
          expect do
            do_request(
              method,
              api_path,
              params: {
                access_token: access_token.token,
                question: attributes_for(:question, :invalid)
              },
              headers: headers
            )
          end.to_not change(Question, :count)
        end

        it 'returns 422 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: access_token.token,
              question: attributes_for(:question, :invalid)
            },
            headers: headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      context 'As author' do
        let(:owner_access_token) { create(:access_token, resource_owner_id: question.author.id) }
        let(:new_question_attributes) { attributes_for(:question) }

        context 'With valid attributes' do
          before do
            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token,
                question: new_question_attributes 
              },
              headers: headers
            )
          end

          it 'changes question attributes' do
            question.reload
            expect(question.title).to eq new_question_attributes[:title]
          end

          it 'returns 200 status' do
            expect(response).to be_successful
          end
        end

        context 'With invalid attributes' do
          it 'does not change question attributes' do
            old_question = question

            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token,
                question: attributes_for(:question, :invalid) 
              },
              headers: headers
            )

            question.reload
            expect(question.title).to eq old_question.title
            expect(question.body).to eq old_question.body
          end

          it 'returns 422 status' do
            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token,
                question: attributes_for(:question, :invalid) 
              },
              headers: headers
            )

            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      context 'As another user' do
        let(:user) { create(:user) }
        let(:user_access_token) { create(:access_token, resource_owner_id: user.id) }

        it 'returns 403 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: user_access_token.token,
              question: attributes_for(:question) 
            },
            headers: headers
          )

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:question_author) { question.author }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:owner_access_token) { create(:access_token, resource_owner_id: question_author.id) }

      context 'As author' do
        it 'deletes the question' do
          expect do
            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token
              },
              headers: headers
            )
          end.to change(question_author.questions, :count).by(-1)
        end

        it 'returns 200 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: owner_access_token.token
            },
            headers: headers
          )

          expect(response).to be_successful
        end
      end

      context 'As another user' do
        let(:user_access_token) { create(:access_token) }

        it 'does not delete the question' do
          expect do
            do_request(
              method,
              api_path,
              params: {
                access_token: user_access_token.token
              },
              headers: headers
            )
          end.to_not change(question_author.questions, :count)
        end

        it 'returns 403 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: user_access_token.token
            },
            headers: headers
          )

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
