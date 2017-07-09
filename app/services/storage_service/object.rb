module StorageService
  class Object

    def initialize(object_key)
      @s3_object = bucket.object(object_key)
    end

    def url
      presigner.presigned_url(:get_object, bucket: bucket.name, key: s3_object.key)
    end

    def delete
      s3_object.delete
    end

    protected

      attr_reader :s3_object

      def bucket
        @bucket ||= Aws::S3::Bucket.new(StorageService.bucket)
      end

      def presigner
        # TODO use a different mode as documented here http://docs.aws.amazon.com/sdk-for-ruby/v2/developer-guide/aws-sdk-ruby-dg.pdf
        @presigner ||= Aws::S3::Presigner.new
      end
  end
end
