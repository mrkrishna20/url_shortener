# spec/controllers/urls_controller_spec.rb
require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  let!(:url) { create(:url, original_url: 'https://www.example.com') }  # Assuming a factory for Url model
  let(:valid_url) { { original_url: 'https://www.test.com' } }
  let(:invalid_url) { { original_url: 'invalid-url' } }

  describe 'POST /urls' do
    context 'when the URL is valid' do
      it 'shortens the URL and returns the shortened URL' do
        post :create, params: { url: valid_url }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['shortened_url']).to be_present
      end
    end

    context 'when the URL is invalid' do
      it 'returns an error message' do
        post :create, params: { url: invalid_url }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid URL')
      end
    end
  end

  describe 'GET /urls/:shortened_url' do
    context 'when the shortened URL exists' do
      it 'redirects to the original URL' do
        get :show, params: { shortened_url: url.shortened_url }

        expect(response).to have_http_status(:redirect)
        expect(response.location).to eq(url.original_url)
      end
    end

    context 'when the shortened URL does not exist' do
      it 'returns an error message' do
        get :show, params: { shortened_url: 'nonexistent' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('URL not found')
      end
    end
  end
end
