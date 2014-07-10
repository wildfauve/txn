class TradingManager

  include Publisher
  
  attr_accessor :order
  
  def self.get_trade_status(trade_id: nil)
    t = self.new({id: trade_id})
    t
  end
    
  
  def initialize(params)
    params[:id] ? @order = Order.find(params[:id]) :  @trade = params
  end
  
  def execute
    self.send(@trade[:order_type])
  end
  
  
  def transfer_quota
    self.perform
  end
  
  def assign_quota    
    self.perform
  end
  
  def perform
    @order = Order.create(@trade)
    if @order.valid?
      @order.execute_trade
      @order.save_everything
      publish(:trade_accepted, self)              
    else
      #rescue Exceptions::TradesError => e
      #if !@order
      #   @order = Order.create_failed_order(@trade)
      #end   
      #binding.pry
      @order.set_failed_state      
      publish(:trade_failed, self)                
    end
  end
  
end