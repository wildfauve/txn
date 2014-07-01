class CustomerEvent

  attr_accessor :cust_event

  def self.check_for_events
    e = self.new
    e.get_event
    e
  end
  
  def initialize
    @found = true
  end

  def get_event
    key = "cust_queue"
    event = $redis.lpop(key)
    event.nil? ? @found = false : @cust_event = JSON.parse(event)
    Rails.logger.info(">>>CustomerEvent: event: #{@cust_event.inspect} to process: #{@found}"  )    
    self.process if @found
  end
  
  def process
    account = Account.get_by_client_number(client_number: @cust_event["number"])
    Rails.logger.info(">>>CustomerEvent: Process Event for: #{account.inspect}")        
    account ? account.update_by_event(event: @cust_event) : Account.create_by_event(event: @cust_event)
  end
  
end

