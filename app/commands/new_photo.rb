class NewPhoto
  include Wisper::Publisher

  def call
    events = Event.order(created_at: :desc).limit(50)
    publish :success, events
  end

end
