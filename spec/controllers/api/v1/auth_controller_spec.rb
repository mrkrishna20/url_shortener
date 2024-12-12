# spec/controllers/api/v1/auth_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  let(:user) { create(:user, email: 'user@example.com', password: 'password123') } # Assuming FactoryBot for User
  let(:valid_params) { { user: { email: 'newuser@example.com', password: 'password123', password_confirmation: 'password123' } } }
  let(:invalid_params) { { user: { email: '', password: '', password_confirmation: '' } } }
  let(:login_params) { { email: 'user@example.com', password: 'password123' } }
  let(:invalid_login_params) { { email: 'user@example.com', password: 'wrongpassword' } }

  describe 'POST #signup' do
    context 'with valid parameters' do
      it 'creates a new user and returns a JWT token' do
        post :signup, params: valid_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login successfully')
        expect(JSON.parse(response.body)['token']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns an error message' do
        post :signup, params: invalid_params

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end

  describe 'POST #login' do
    context 'with valid credentials' do
      it 'returns a JWT token for the user' do
        post :login, params: login_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Login successfully')
        expect(JSON.parse(response.body)['token']).to be_present
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message for invalid login' do
        post :login, params: invalid_login_params

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Not Authorized')
      end
    end
  end
end
