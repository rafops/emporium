module CloudStorage

  class << self
    def available?
      aws_region            and
      aws_access_key_id     and
      aws_secret_access_key and
      aws_bucket
    end

    def endpoint
      "https://#{aws_bucket}.s3.amazonaws.com"
    end

    def aws_region
      Rails.application.secrets.aws_region
    end

    def aws_access_key_id
      Rails.application.secrets.aws_access_key_id
    end

    def aws_secret_access_key
      Rails.application.secrets.aws_secret_access_key
    end

    def aws_bucket
      Rails.application.secrets.aws_bucket
    end

    ## TODO fix this shit
    def config
      @config ||= Aws.config.update(
        region: Rails.application.secrets.aws_region,
        credentials: Aws::Credentials.new(
          Rails.application.secrets.aws_access_key_id,
          Rails.application.secrets.aws_secret_access_key
        )
      )
    end

  end

end
