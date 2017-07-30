class CreateEvent
  include Wisper::Publisher

  def initialize(**event_attributes)
    @event_attributes = event_attributes
  end

  def call
    title = event_attributes[:title]
    event = Event.entitled(title).first unless title.blank?
    event = Event.create(event_attributes) unless event

    if event.valid?
      publish :success, event
    else
      error_messages = event.errors.messages.first.flatten.join(' ')
      publish :validation_error, event, error_messages
    end
  end

  protected

    attr_reader :event_attributes
end
