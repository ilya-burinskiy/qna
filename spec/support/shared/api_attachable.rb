shared_examples_for 'API Attachable' do
  context 'Authorized' do
    before do
      attachable.files.attach(io: File.open("#{Rails.root}/db/seeds.rb"), filename: 'seeds.rb')
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
    end

    it 'returns attached files' do
      expect(attachable_response['files'].size).to eq attachable.files.size
    end
  end
end
