class CreateUpload
  include Wisper::Publisher

  def initialize(attributes)
    @attributes = attributes
  end

  def call
    upload = Upload.create(attributes)

    if upload.valid?
      # TODO move upload.url out of the model
      publish :success, upload, upload.url
    else
      error_messages = upload.errors.messages.first.flatten.join(' ')
      publish :validation_error, upload, error_messages
    end
  end

  protected

    attr_reader :attributes
end
