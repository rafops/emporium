class ListEventsHome
  include Wisper::Publisher

  PAGE_SIZE = 25

  def initialize(page: 0)
    @page = page
  end

  def call
    events = Event.joins(photos: :thumbnails)
                  .includes(photos: :thumbnails)
                  .order(created_at: :desc)
    events = events.offset(page).limit(PAGE_SIZE)

    if events.any?
      publish :success, events
    else
      publish :not_found
    end
  end

  protected

    attr_reader :page
end
