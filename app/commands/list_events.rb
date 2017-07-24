class ListEvents
  include Wisper::Publisher

  def initialize(title: nil)
    @title = title
  end

  def call
    events = title.blank? ? Event.all : Event.where_title_like(title)

    if events.any?
      publish :success, events
    else
      publish :not_found
    end
  end

  protected

    attr_reader :title
end
