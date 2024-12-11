class UrlsController < ApplicationController

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      flash[:success] = "Short Url created: #{url_for(@url.short_url)}"
      redirect_to :show
    else
      flash[:error] = "Invalid Url"
      render :new
    end
  end

  private

  def url_params
    params.require(:url).permit(:long_url)
  end
end
