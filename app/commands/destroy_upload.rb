class DestroyUpload
  include Wisper::Publisher

  def initialize(uuid)
    @uuid = uuid
  end

  def call
    upload = Upload.find_by_uuid(uuid)

    if upload.destroy
      publish :success
    else
      publish :failure
    end
  end

  protected

    attr_reader :uuid
end
