class ListPhotos
  include Wisper::Publisher

  def call
    thumbnails = Photo.thumbnail.joins(:original).includes(:original).order(created_at: :desc)
    if thumbnails.any?
      publish :success, thumbnails
    else
      publish :not_found
    end
  end
end
