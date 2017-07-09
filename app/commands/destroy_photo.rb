class DestroyPhoto
  include Wisper::Publisher

  def initialize(storage_service_object: StorageService::Object, **photo_attributes)
    @storage_service_object = storage_service_object
    @photo_attributes = photo_attributes
  end

  def call
    photo = Photo.find_by_uuid(photo_attributes[:uuid])
    return publish :not_found unless photo

    if photo.destroy
      storage_service_object.new(photo.object_key).delete
      publish :success
    else
      publish :failure
    end
  end

  protected

    attr_reader :photo_attributes, :storage_service_object
end
