class CreateUpload
  include Wisper::Publisher

  def initialize(cloud_storage_object: CloudStorage::Object, **upload_attributes)
    @cloud_storage_object = cloud_storage_object
    @upload_attributes = upload_attributes
  end

  def call
    upload = Upload.create(upload_attributes)

    if upload.valid?
      url = cloud_storage_object.new(upload.object_key).presigned_url
      publish :success, upload, url
    else
      error_messages = upload.errors.messages.first.flatten.join(' ')
      publish :validation_error, upload, error_messages
    end
  end

  protected

    attr_reader :upload_attributes, :cloud_storage_object
end
