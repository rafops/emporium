class Upload < ApplicationRecord

  validates :object_key, presence: true
  validates :uuid, presence: true, uniqueness: true
  before_destroy :delete_from_s3

  def url
    signer = Aws::S3::Presigner.new
    signer.presigned_url(:get_object, bucket: bucket, key: object_key)
  end

  private

  def bucket
    ENV['AWS_BUCKET']
  end

  def delete_from_s3
    bucket_object = Aws::S3::Bucket.new(bucket)
    s3_object = bucket_object.object(object_key)
    s3_object.delete()
  end
end
