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
    @order.execute_trade
    @order.save_everything
    publish(:trade_accepted, order)              
  end
  
end