module StorageService

  class << self
    def available?
      region            and
      access_key_id     and
      secret_access_key and
      bucket
    end

    def endpoint
      "https://#{bucket}.s3.amazonaws.com"
    end

    def region
      Rails.application.secrets.aws_region
    end

    def access_key_id
      Rails.application.secrets.aws_access_key_id
    end

    def secret_access_key
      Rails.application.secrets.aws_secret_access_key
    end

    def bucket
      Rails.application.secrets.aws_bucket
    end

    ## TODO fix this shit
    def config
      @config ||= Aws.config.update(
        region: region,
        credentials: Aws::Credentials.new(
          access_key_id,
          secret_access_key
        )
      )
    end

  end

end
