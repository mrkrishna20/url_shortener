class UrlsController < ApplicationController
  before_action :authenticate_user!

  def new
    @url = current_user.urls.new
  end

  def create
    @url = current_user.urls.new(url_params)
    if @url.save
      flash[:success] = "Short Url created: #{url_for(@url.short_url)}"
      redirect_to @url, notice: 'Url was successfully created'
    else
      flash[:error] = "Invalid Url"
      render :new
    end
  end

  def show
    @url = current_user.urls.find(params[:id])
    @full_short_url = "http://localhost:3000/#{@url.short_url}"
  end

  def redirect_original_url
    @url = current_user.urls.find_by(short_url: params[:short_url])
    if @url
      redirect_to @url.long_url, allow_other_host: true
    else
      render plain: 'URL not found', status: :not_found
    end
  end

  private

  def url_params
    params.require(:url).permit(:long_url)
  end
end
