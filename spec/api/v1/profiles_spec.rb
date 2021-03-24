require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    {
      "CONTENT_TYPE" => "application/json", 
      "ACCEPT" => "application/json"
    }
  end

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email type created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:users_response) { json['users'] }

      before do
        get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns profiles list of all non authenticated users' do
        expect(users_response.size).to eq users.size
      end

      it 'returns all public profile fields of all non authenticated users' do
        users.each_with_index do |user, i|
          %w[id email type created_at updated_at].each do |attr|
            expect(users_response[i][attr]).to eq user.send(attr).as_json
          end
        end
      end

      it 'does not return private profile fields of all non authenticated users' do
        users.each_with_index do |user, i|
          %w[password encrypted_password].each do |attr|
            expect(users_response[i]).to_not have_key(attr)
          end
        end
      end

      it 'does not return profile of authenticated user' do
        expect(
          users_response.any? do |user|
            user['id'] == me.id
          end
        ).to be_falsey
      end
    end
  end
end
