module CloudStorage

  class << self
    def available?
      ENV.has_key?('AWS_REGION') and
      ENV.has_key?('AWS_ACCESS_KEY_ID') and
      ENV.has_key?('AWS_SECRET_ACCESS_KEY') and
      ENV.has_key?('AWS_BUCKET')
    end

    def endpoint
      "https://#{ENV.fetch('AWS_BUCKET')}.s3.amazonaws.com"
    end

    def accessKey
      ENV.fetch('AWS_ACCESS_KEY_ID')
    end
  end

end
