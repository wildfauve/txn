class StockHolding
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_symbol, type: Symbol
  field :qty, type: Integer, default: 0
  
  embedded_in :account
    
  def self.create_holding(stock_entry: nil)
    h = self.new
    h.stock_symbol = stock_entry.stock_concept.symbol
    h.qty = 0
    h
  end
  
  def add(qty: nil)
    self.qty += qty
    self
  end
  
  def remove(qty: nil)
    self.qty -= qty
    self
  end
    
end