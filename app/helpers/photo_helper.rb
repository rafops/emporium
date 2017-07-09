module PhotoHelper
  def photo_url(photo)
    StorageService::Object.new(photo.object_key).url
  end
end
