class HomeController < ApplicationController
  def index
    list_events_home.on :success do |events|
      respond_to do |format|
        format.html { render :index, locals: { events: events } }
      end
    end

    list_events_home.on :not_found do
      respond_to do |format|
        format.html { render :index, locals: { events: [] } }
      end
    end

    list_events_home.call
  end

  private

    def list_events_home
      @list_events_home ||= ListEventsHome.new
    end

end
