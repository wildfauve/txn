class TradingManager

  include Publisher
  
  attr_accessor :order
  
  def initialize(params)
    @trade = params
  end
  
  def assign_quota    
    @order = Order.create(@trade)
    @order.execute_trade
    publish(:trade_accepted, order)          
  end
  
end