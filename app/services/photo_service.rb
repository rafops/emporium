module PhotoService

  THUMBNAIL_SIZE = 'thumbnail'
  WATERMARK_THRESHOLD = 1000

  class << self
    def url(photo)
      StorageService::Object.new(photo.object_key).url
    end

    def uploader_sizes
      Photo.sizes.map { |k,v| { name: k, maxSize: v } }
    end

    def thumbnail_size
      Photo.sizes[THUMBNAIL_SIZE]
    end
  end

end
