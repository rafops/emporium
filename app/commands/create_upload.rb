class CreateUpload
  include Wisper::Publisher

  def initialize(attributes)
    @attributes = attributes
  end

  def call
    upload = Upload.create(attributes)

    if upload.valid?
      url = CloudStorage::Object.new(upload.object_key).presigned_url
      publish :success, upload, url
    else
      error_messages = upload.errors.messages.first.flatten.join(' ')
      publish :validation_error, upload, error_messages
    end
  end

  protected

    attr_reader :attributes
end
