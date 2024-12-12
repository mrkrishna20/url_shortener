class Api::V1::UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  def create
    url = @current_user.urls.new(url_params)

    if url.save
      render json: { short_url: "http://localhost:3000/#{url.short_url}" }, status: :created
    else
      render json: { error: url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def url_params
    params.require(:url).permit(:long_url)
  end

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token) if token
    @current_user = User.find_by(id: decoded['user_id']) if decoded

    render json: { error: 'Not Authorized'}, status: :unauthorized unless @current_user
  end
end
