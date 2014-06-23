module Publisher
  def add_subscriber(object)
    @subscribers ||= []
    @subscribers << object
  end

  def publish(message, *args)
    return if @subscribers.blank?
    @subscribers.each do |subscriber|
      subscriber.send(message, *args) if subscriber.respond_to?(message)
    end
  end
end