class StockEntry
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_qty, type: Integer
  field :stock_id, type: BSON::ObjectId
  
  embedded_in :order
  
  
  def self.create_entries(stocks: nil)
    ent = []
    stocks.each do |stock| 
      s = self.new
      ent << s.create_entry(stock: stock)
    end
    ent
  end
  
  def create_entry(stock: nil)
    self.stock_qty = stock[:ordered_qty].to_i
    ref_stock = Stock.where(symbol: stock[:symbol].to_sym).first
    self.stock_id = ref_stock.id
    self    
  end
  
  def stock_concept
    @concept ||= Stock.find(self.stock_id)
  end
  
end

