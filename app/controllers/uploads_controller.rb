class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

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

  def create
    create_upload.on :success do |upload, url|
      respond_to do |format|
        format.json { render json: { 'tempLink' => url } }
      end
    end

    create_upload.on :validation_error do |upload, error_messages|
      respond_to do |format|
        format.json { render json: { 'error' => error_messages, 'preventRetry' => true }, status: :unprocessable_entity }
      end
    end

    create_upload.call
  end

  def destroy
    destroy_upload.on :success do
      respond_to do |format|
        format.json { render json: {}, state: :ok }
      end
    end

    destroy_upload.on :failure do
      respond_to do |format|
        format.json { render json: {}, state: :unprocessable_entity }
      end
    end

    destroy_upload.call
  end

  private

    def sign_upload
      @sign_upload ||= SignUpload.new(request.raw_post)
    end

    def upload_params
      original = params.permit(:key, :uuid, :name)
      object_key = original.delete(:key)
      original.merge({ object_key: object_key })
    end

    def create_upload
      @create_upload ||= CreateUpload.new(upload_params)
    end

    def destroy_upload_params
      params.permit(:uuid)
    end

    def destroy_upload
      @destroy_upload ||= DestroyUpload.new(destroy_upload_params[:uuid])
    end
end
