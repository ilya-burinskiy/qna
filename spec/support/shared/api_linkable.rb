shared_examples_for 'API Linkable' do
  context 'Authorized' do
    let!(:links) { create_list(:link, 3, linkable_klass, linkable: linkable) }

    before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

    it 'returns list of links' do
      expect(linkable_response['links'].size).to eq linkable.links.size
    end

    it 'returns links fields' do
      linkable.links.each_with_index do |link, i|
        %w[id name url created_at updated_at].each do |attr|
          expect(linkable_response['links'][i][attr]).to eq link.send(attr).as_json
        end
      end 
    end
  end
end
