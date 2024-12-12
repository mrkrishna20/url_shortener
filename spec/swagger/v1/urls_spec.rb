require 'swagger_helper'

RSpec.describe 'API::V1::UrlsController', type: :request do
  path '/api/v1/urls' do
    post 'Shorten a URL' do
      tags 'URLs'
      consumes 'application/json'
      produces 'application/json'

      # Define request parameters
      parameter name: :url, in: :body, schema: {
          type: :object,
          properties: {
              long_url: { type: :string, example: 'http://www.example.com' }
          },
          required: ['long_url']
      }

      response '201', 'URL shortened' do
        schema type: :object,
               properties: {
                   short_url: { type: :string, example: 'http://localhost:3000/abc123' }
               },
               required: ['short_url']

        let(:url) { { long_url: 'http://www.example.com' } }
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
               properties: {
                   error: { type: :string, example: 'Not Authorized' }
               },
               required: ['error']

        let(:Authorization) { 'Bearer invalid_token' }
        let(:url) { { long_url: 'http://www.example.com' } }
        run_test!
      end

      response '422', 'Invalid URL' do
        schema type: :object,
               properties: {
                   error: { type: :array, items: { type: :string }, example: ['Long URL can\'t be blank'] }
               },
               required: ['error']

        let(:url) { { long_url: '' } }
        run_test!
      end
    end
  end
end
