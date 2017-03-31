class DestroyUpload
  include Wisper::Publisher

  def initialize(cloud_storage_object: CloudStorage::Object, **upload_attributes)
    @cloud_storage_object = cloud_storage_object
    @upload_attributes = upload_attributes
  end

  def call
    upload = Upload.find_by_uuid(upload_attributes[:uuid])
    return publish :not_found unless upload

    if upload.destroy
      cloud_storage_object.new(upload.object_key).delete
      publish :success
    else
      publish :failure
    end
  end

  protected

    attr_reader :upload_attributes, :cloud_storage_object
end
