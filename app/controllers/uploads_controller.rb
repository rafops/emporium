class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def sign
    sign_upload.on :signed_headers do |signature|
      respond_to do |format|
        format.json { render json: { 'signature' => signature } }
      end
    end

    sign_upload.on :signed_policy do |signature, policy|
      respond_to do |format|
        format.json { render json: { 'signature' => signature, 'policy' => policy } }
      end
    end

    sign_upload.call
  end

  private

    def sign_upload
      @sign_upload ||= SignUpload.new(request.raw_post)
    end

end
