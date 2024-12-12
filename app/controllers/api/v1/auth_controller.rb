class Api::V1::AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def signup
    user = User.new(user_params)
    if user.save
      render json: { message: 'Login successfully', token: generate_jwt(user)}
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { message: 'Login successfully', token: token }
    else
      render json: { error: 'Not Authorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def generate_jwt(user)
    JsonWebToken.encode(user)
  end
end
