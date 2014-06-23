class Account
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :client_number, type: String
  field :client_name, type: String

  embeds_many :stock_holdings
  
  
  def add_to_holdings(stock: nil, qty: nil)
    holding = get_holding(stock: stock)
    holding.add(qty: qty)
    self.save
    self
  end
  
  def get_holding(stock: nil)
    holding = self.stock_holdings.where(stock_symbol: stock.symbol).first
    if !holding
      holding = StockHolding.create_holding(stock: stock) if !holding
      self.stock_holdings << holding
    end
    holding
  end
  
end
