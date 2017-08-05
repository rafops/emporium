class PhotosController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  # protect_from_forgery prepend: false

  def new
  end

  def create
    create_photo.on :success do |photo, url|
      respond_to do |format|
        format.json { render json: { 'tempLink' => url } }
      end
    end

    create_photo.on :validation_error do |photo, error_messages|
      respond_to do |format|
        format.json { render json: { 'error' => error_messages, 'preventRetry' => true }, status: :unprocessable_entity }
      end
    end

    create_photo.call
  end

  def destroy
    destroy_photo.on :not_found do
      respond_to do |format|
        format.json { render json: {}, state: :not_found }
      end
    end

    destroy_photo.on :success do
      respond_to do |format|
        format.json { render json: {}, state: :ok }
      end
    end

    destroy_photo.on :failure do
      respond_to do |format|
        format.json { render json: {}, state: :unprocessable_entity }
      end
    end

    destroy_photo.call
  end

  private

    def photo_params
      original = params.permit(:key, :qquuid, :qqparentuuid, :name, :event_uuid)
      object_key = original.delete(:key)
      uuid = original.delete(:qquuid)
      parent_uuid = original.delete(:qqparentuuid)
      original.merge(
        object_key: object_key,
        uuid: uuid,
        parent_uuid: parent_uuid
      )
    end

    def new_photo
      @new_photo ||= NewPhoto.new
    end

    def create_photo
      @create_photo ||= CreatePhoto.new(photo_params.to_h.symbolize_keys)
    end

    def destroy_photo_params
      params.permit(:uuid)
    end

    def destroy_photo
      @destroy_photo ||= DestroyPhoto.new(destroy_photo_params.to_h.symbolize_keys)
    end
end
