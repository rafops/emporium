class CloudStorageObject

  def initialize(object_key)
    @s3_object = bucket.object(object_key)
  end

  def presigned_url
    presigner.presigned_url(:get_object, bucket: bucket.name, key: s3_object.key)
  end

  def delete
    s3_object.delete
  end

  protected

    attr_reader :s3_object

    def bucket
      @bucket ||= Aws::S3::Bucket.new(ENV.fetch('AWS_BUCKET'))
    end

    def presigner
      @presigner ||= Aws::S3::Presigner.new
    end
end
