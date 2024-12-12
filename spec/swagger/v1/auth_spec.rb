require 'swagger_helper'

RSpec.describe 'API::V1::AuthController', type: :request do
  path '/api/v1/signup' do
    post 'User Signup' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
          },
          required: %w[email password password_confirmation]
      }

      response '200', 'Signup Successful' do
        schema type: :object,
               properties: {
                   message: { type: :string },
                   token: { type: :string }
               },
               required: %w[message token]

        let(:user) { { email: 'user@example.com', password: 'password123', password_confirmation: 'password123' } }
        run_test!
      end

      response '401', 'Signup Failed' do
        schema type: :object,
               properties: {
                   error: { type: :string }
               },
               required: ['error']

        let(:user) { { email: '', password: '', password_confirmation: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/login' do
    post 'User Login' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
          type: :object,
          properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' }
          },
          required: %w[email password]
      }

      response '200', 'Login Successful' do
        schema type: :object,
               properties: {
                   message: { type: :string },
                   token: { type: :string }
               },
               required: %w[message token]

        let(:credentials) { { email: 'user@example.com', password: 'password123' } }
        run_test!
      end

      response '401', 'Login Failed' do
        schema type: :object,
               properties: {
                   error: { type: :string }
               },
               required: ['error']

        let(:credentials) { { email: 'wrong@example.com', password: 'wrongpassword' } }
        run_test!
      end
    end
  end
end
