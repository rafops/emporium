class EventsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    list_events.on :success do |events|
      respond_to do |format|
        format.json { render json: events }
      end
    end

    list_events.on :not_found do
      respond_to do |format|
        format.json { render json: [], state: :not_found }
      end
    end

    list_events.call
  end

  def create
    create_event.on :success do |event|
      respond_to do |format|
        format.json { render json: event }
      end
    end

    create_event.on :validation_error do |event, error_messages|
      respond_to do |format|
        format.json { render json: { 'error' => error_messages }, status: :unprocessable_entity }
      end
    end

    create_event.call
  end

  def show    
    list_thumbnails.on :success do |thumbnails|
      respond_to do |format|
        format.html { render :show, locals: { thumbnails: thumbnails } }
      end
    end

    list_thumbnails.on :not_found do
      respond_to do |format|
        format.html { render :show, locals: { thumbnails: [] } }
      end
    end

    list_thumbnails.call
  end

  private

    def event_params
      params.permit(:title)
    end

    def list_events
      @list_events ||= ListEvents.new(event_params.to_h.symbolize_keys)
    end

    def create_event
      @create_event ||= CreateEvent.new(event_params.to_h.symbolize_keys)
    end

    def list_thumbnails
      @list_thumbnails ||= ListThumbnails.new(event: Event.find_by_uuid(params[:uuid]))
    end

end