class DestroyUpload
  include Wisper::Publisher

  def initialize(uuid)
    @uuid = uuid
  end

  def call
    upload = Upload.find_by_uuid(uuid)

    if upload.destroy
      CloudStorage::Object.new(upload.object_key).delete
      publish :success
    else
      publish :failure
    end
  end

  protected

    attr_reader :uuid
end
