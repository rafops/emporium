class ListThumbnails
  include Wisper::Publisher

  def initialize(event:)
    @event = event
  end

  def call
    thumbnails = Photo.where(event: event).thumbnail.joins(:original).includes(:original)
    if thumbnails.any?
      publish :success, thumbnails
    else
      publish :not_found
    end
  end

  protected

    attr_reader :event
end
