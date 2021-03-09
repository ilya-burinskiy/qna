require 'rails_helper'

shared_examples_for 'voted' do
  let(:votable_klass) { described_class.controller_name.classify.underscore.to_sym }
  let(:votable) { create(votable_klass) }
  let(:user) { create(:user) }
  let(:vote) { create(:vote, votable_klass) }

  describe 'POST #vote_for' do
    describe 'Authenticated user' do
      before { login(user) }

      context 'User is not votable author' do
        it 'assigns votable' do
          post :vote_for, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it 'creates new for vote' do
          user_assigned_votes_count = user.assigned_votes.count
          post :vote_for, params: { id: votable }, format: :json

          expect(user.assigned_votes.count).to eq user_assigned_votes_count + 1
          expect(user.assigned_votes.last.status).to eq 1
        end

        it 'responds with json' do
          post :vote_for, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end

      context 'User is votable author' do
        before { login(votable.author) }

        it 'assigns votable' do
          post :vote_for, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it 'does not create new for vote' do
          expect { post :vote_for, params: { id: votable }, format: :json }.to_not change(votable.author.assigned_votes, :count)
        end

        it 'responds with json' do
          post :vote_for, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'responses with unauthorized status' do
        post :vote_for, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #vote_against' do
    describe 'Authenticated user' do
      before { login(user) }

      context 'User is not votable author' do
        it 'assigns votable' do
          post :vote_against, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it 'creates new against vote' do
          user_assigned_votes_count = user.assigned_votes.count
          post :vote_against, params: { id: votable }, format: :json

          expect(user.assigned_votes.count).to eq user_assigned_votes_count + 1
          expect(user.assigned_votes.last.status).to eq -1
        end

        it 'responds with json' do
          post :vote_against, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end

      context 'User is votable author' do
        before { login(votable.author) }

        it 'assigns votable' do
          post :vote_against, params: { id: votable }, format: :json
          expect(assigns(:votable)).to eq votable
        end

        it 'does not create new for vote' do
          expect { post :vote_against, params: { id: votable }, format: :json }.to_not change(votable.author.assigned_votes, :count)
        end

        it 'responds with json' do
          post :vote_against, params: { id: votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'responses with unauthorized status' do
        post :vote_against, params: { id: votable }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end

  describe 'DELETE #unvote' do
    context 'Authenticated user' do
      context 'Vote author' do
        before { login(vote.voter) }

        it 'deletes vote' do
          expect { delete :unvote, params: { id: vote.votable }, format: :json }.to change(vote.voter.assigned_votes, :count).by(-1)
        end

        it 'responds with json' do
          delete :unvote, params: { id: vote.votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end

      context 'Not vote author' do
        before { login(user) }

        it 'does not deletes vote' do
          expect { delete :unvote, params: { id: vote.votable }, format: :json }.to_not change(vote.voter.assigned_votes, :count)
        end

        it 'responds with json' do
          delete :unvote, params: { id: vote.votable }, format: :json
          expect(response.content_type).to eq 'application/json; charset=utf-8'
        end
      end
    end
  end

  context 'Unauthenticated user' do
    it 'does not deletes vote' do
      expect { delete :unvote, params: { id: vote.votable }, format: :json }.to_not change(vote.voter.assigned_votes, :count)
    end

    it 'responses with unauthorized status' do
      delete :unvote, params: { id: vote.votable }, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
