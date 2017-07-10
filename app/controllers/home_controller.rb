class HomeController < ApplicationController
  def index
    @thumbnails = Photo.thumbnail.joins(:original).order(created_at: :desc)
  end
end
