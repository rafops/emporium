class HomeController < ApplicationController
  def index
    list_photos.on :success do |thumbnails|
      respond_to do |format|
        format.html { render :index, locals: { thumbnails: thumbnails } }
      end
    end

    list_photos.on :not_found do
      respond_to do |format|
        format.json { render :index, locals: { thumbnails: [] } }
      end
    end

    list_photos.call
  end

  private

    def list_photos
      @list_photos ||= ListPhotos.new
    end

end
