class CreatePhoto
  include Wisper::Publisher

  def initialize(cloud_storage_object: CloudStorage::Object, **photo_attributes)
    @cloud_storage_object = cloud_storage_object
    @photo_attributes = photo_attributes
  end

  def call
    photo = Photo.create(photo_attributes)

    if photo.valid?
      url = cloud_storage_object.new(photo.object_key).url
      publish :success, photo, url
    else
      error_messages = photo.errors.messages.first.flatten.join(' ')
      publish :validation_error, photo, error_messages
    end
  end

  protected

    attr_reader :photo_attributes, :cloud_storage_object
end
