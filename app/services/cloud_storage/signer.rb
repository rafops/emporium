# Reference
# https://github.com/FineUploader/php-s3-server/blob/master/endpoint-cors.php
module CloudStorage
  class Signer

    def initialize(raw_post)
      @raw_post = raw_post
      @json_request = JSON.parse(raw_post)
    end

    def headers_only?
      json_request['headers'].present?
    end

    def headers_signature
      headers = json_request['headers'].split("\n")
      credential_scope_index = headers.index { |s| s.match /^\d{8}\/.+\/s3\/aws4_request$/ }
      canonical_headers = headers.slice(credential_scope_index+1..-1)
      canonical_headers_digest = hexdigest(canonical_headers.join("\n"))
      string_to_sign = (headers.slice(0..credential_scope_index) + [canonical_headers_digest]).join("\n")
      signature(string_to_sign, json_request)
    end

    def encoded_policy
      @_encoded_policy ||= Base64.encode64(raw_post).gsub("\n", '')
    end

    def policy_signature
      signature(encoded_policy, json_request)
    end

    protected

      attr_reader :raw_post, :json_request

      # VERSION 4
      # Extracted from lib/aws-sdk-core/signers/v4.rb
      # http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-query-string-auth.html
      # http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-UsingHTTPPOST.html

      def hexdigest(value)
        Aws::Checksums.sha256_hexdigest(value)
      end

      def hmac(key, value)
        OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, value)
      end

      def hexhmac(key, value)
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, value)
      end

      def date_and_region(json_request)
        if json_request['headers'] # multipart
          header = json_request['headers'].split("\n").select { |s| s.match /^\d{8}\/[\w\-]+\/s3\/aws4_request$/ }.first
          header.split('/').slice(0..1)
        else
          credential_scope = json_request['conditions'].select { |h| h.is_a?(Hash) && h.keys.first == 'x-amz-credential' }.first.values.first
          credential_scope.split('/').slice(1..2)
        end
      end

      def signature(payload, json_request)
        date, region = date_and_region(json_request)
        k_date = hmac("AWS4#{CloudStorage.aws_secret_access_key}", date)
        k_region = hmac(k_date, region)
        k_service = hmac(k_region, 's3')
        k_credentials = hmac(k_service, 'aws4_request')
        hexhmac(k_credentials, payload)
      end
  end
end
