class Stock
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :symbol, type: Symbol
  field :ref_id, type: String
  field :total_shares, type: Integer
  
  has_many :orders
  
  def self.get_by_symbol(symbol: nil)
    sym = symbol.downcase.to_sym
    stock = self.where(symbol: sym).first
    stock ? stock : self.new.create_stock(symbol: sym) 
  end
  
  def create_stock(symbol: nil)
    self.symbol = symbol
    self.save!
    self
  end
  
end