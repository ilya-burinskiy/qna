require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answers, 3, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of question answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end

    describe 'GET /api/v1/answers/:id' do
      let(:answer) { create(:answer) }
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:access_token) { create(:access_token) }

      it_behaves_like 'API Authorizable'

      it_behaves_like 'API Linkable' do
        let(:linkable) { answer }
        let(:linkable_klass) { :answer }
        let(:linkable_response) { json['answer'] }
      end
      
      it_behaves_like 'API Commentable' do
        let(:commentable) { answer }
        let(:commentable_klass) { :answer }
        let(:commentable_response) { json['answer'] }
      end

      it_behaves_like 'API Attachable' do
        let(:attachable) { answer }
        let(:attachable_response) { json['answer'] }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token) }

    it_behaves_like 'API Authorizable'

    it_behaves_like 'API Linkable' do
      let(:linkable) { answer }
      let(:linkable_klass) { :answer }
      let(:linkable_response) { json['answer'] }
    end
    
    it_behaves_like 'API Commentable' do
      let(:commentable) { answer }
      let(:commentable_klass) { :answer }
      let(:commentable_response) { json['answer'] }
    end

    it_behaves_like 'API Attachable' do
      let(:attachable) { answer }
      let(:attachable_response) { json['answer'] }
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      
      context 'With valid attributes' do
        it 'saves a new answer in the database' do
          expect do
            do_request(
              method,
              api_path,
              params: {
                access_token: access_token.token,
                answer: attributes_for(:answer)
              },
              headers: headers
            )

          end.to change(question.answers, :count).by(1)
        end

        it 'has 200 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: access_token.token,
              answer: attributes_for(:answer)
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
              answer: attributes_for(:answer)
            },
            headers: headers
          )

          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq assigns(:answer).send(attr).as_json
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
                answer: attributes_for(:answer, :invalid)
              },
              headers: headers
            )
          end.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          do_request(
            method,
            api_path,
            params: {
              access_token: access_token.token,
              answer: attributes_for(:answer, :invalid)
            },
            headers: headers
          )

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      context 'As author' do
        let(:owner_access_token) { create(:access_token, resource_owner_id: answer.author.id) }
        let(:new_answer_attributes) { attributes_for(:answer) }

        context 'With valid attributes' do
          before do
            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token,
                answer: new_answer_attributes 
              },
              headers: headers
            )
          end

          it 'changes answer attributes' do
            answer.reload
            expect(answer.body).to eq new_answer_attributes[:body]
          end

          it 'returns 200 status' do
            expect(response).to be_successful
          end
        end

        context 'With invalid attributes' do
          it 'does not change answer attributes' do
            old_answer = answer

            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token,
                answer: attributes_for(:answer, :invalid) 
              },
              headers: headers
            )

            answer.reload
            expect(answer.body).to eq old_answer.body
          end

          it 'returns 422 status' do
            do_request(
              method,
              api_path,
              params: {
                access_token: owner_access_token.token,
                answer: attributes_for(:answer, :invalid) 
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
              answer: attributes_for(:answer) 
            },
            headers: headers
          )

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:answer_author) { answer.author }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'Authorized' do
      let(:owner_access_token) { create(:access_token, resource_owner_id: answer_author.id) }

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
          end.to change(answer_author.answers, :count).by(-1)
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
          end.to_not change(answer_author.answers, :count)
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
