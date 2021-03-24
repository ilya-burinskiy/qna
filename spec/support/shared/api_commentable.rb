shared_examples_for 'API Commentable' do
  context 'Authorized' do
    let!(:comments) { create_list(:comment, 3, commentable_klass, commentable: commentable) }

    before { do_request(method, api_path, params: { access_token: access_token.token }, headers: headers) }

    it 'returns list of comments' do
      expect(commentable_response['comments'].size).to eq commentable.comments.size
    end

    it 'returns comments fields' do
      commentable.comments.each_with_index do |comment, i|
        %w[id body created_at updated_at].each do |attr|
          expect(commentable_response['comments'][i][attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end
end
