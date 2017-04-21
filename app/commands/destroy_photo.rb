class DestroyPhoto
  include Wisper::Publisher

  def initialize(cloud_storage_object: CloudStorage::Object, **photo_attributes)
    @cloud_storage_object = cloud_storage_object
    @photo_attributes = photo_attributes
  end

  def call
    photo = Photo.find_by_uuid(photo_attributes[:uuid])
    return publish :not_found unless photo

    if photo.destroy
      cloud_storage_object.new(photo.object_key).delete
      publish :success
    else
      publish :failure
    end
  end

  protected

    attr_reader :photo_attributes, :cloud_storage_object
end
