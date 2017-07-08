module CloudStorage
  class Object

    def initialize(object_key)
      @s3_object = bucket.object(object_key)
    end

    def url
      # TODO this method is broken since it depends on environment variables!!!
      presigner.presigned_url(:get_object, bucket: bucket.name, key: s3_object.key)
    end

    def delete
      s3_object.delete
    end

    protected

      attr_reader :s3_object

      def bucket
        @bucket ||= Aws::S3::Bucket.new(CloudStorage.aws_bucket)
      end

      def presigner
        @presigner ||= Aws::S3::Presigner.new
      end
  end
end
