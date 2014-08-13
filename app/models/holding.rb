class Holding
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_symbol, type: Symbol
  field :qty, type: Integer, default: 0
  field :unit, type: Symbol
  
  embedded_in :transaction_account
    
  def self.create_holding(stock_entry: nil)
    h = self.new
    h.stock_symbol = stock_entry.stock_concept.symbol
    h.qty = 0
    h.unit = :share
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
  
  def stock
    Stock.where(symbol: self.stock_symbol).first
  end
    
end