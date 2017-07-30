class CreatePhoto
  include Wisper::Publisher

  def initialize(storage_service_object: StorageService::Object, **photo_attributes)
    @storage_service_object = storage_service_object
    @photo_attributes = photo_attributes
  end

  def call
    update_photo_attributes_event_id
    
    photo = Photo.create(photo_attributes)

    if photo.valid?
      url = storage_service_object.new(photo.object_key).url
      publish :success, photo, url
    else
      error_messages = photo.errors.messages.first.flatten.join(' ')
      publish :validation_error, photo, error_messages
    end
  end

  protected

    attr_reader :photo_attributes, :storage_service_object

  private

    def update_photo_attributes_event_id
      event_uuid = @photo_attributes.delete(:event_uuid)
      event = Event.find_by_uuid(event_uuid) if event_uuid
      @photo_attributes[:event_id] = event.id if event
    end
end
