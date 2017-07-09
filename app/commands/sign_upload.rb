class SignUpload
  include Wisper::Publisher

  def initialize(raw_post)
    @signer = StorageService::Signer.new(raw_post)
  end

  def call
    if @signer.headers_only?
      publish :signed_headers, @signer.headers_signature
    else
      publish :signed_policy, @signer.policy_signature, @signer.encoded_policy
    end
  end
end
