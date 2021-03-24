shared_examples_for 'API Authorizable' do
  context 'Unauthorized' do
    it 'returns 401 status if there is no access token' do
      do_request(method, api_path, headers: headers)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '123' }, headers: headers)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
