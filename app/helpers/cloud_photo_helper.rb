module CloudPhotoHelper
  def get_cloud_storage_object (photo)
    CloudStorage::Object.new(photo.object_key).url
  end
end
