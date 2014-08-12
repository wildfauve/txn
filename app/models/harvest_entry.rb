class HarvestEntry
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_symbol, type: Symbol
  field :stock_id, type: BSON::ObjectId
  field :qty, type: Integer
  field :unit, type: Symbol
  
  embedded_in :harvest_return
  
  def self.create_entry(entry: nil, stock: nil)
    e = self.new
    e.stock_symbol = stock.symbol
    e.stock_id = stock.id
    e.qty = entry[:catch_qty][:qty]
    e.unit = entry[:catch_qty][:unit]
    e
  end
  
  def update_entry(entry: nil, stock: nil)
    #self.stock_code = entry[:stock_code].to_sym if self.stock_code != entry[:stock_code].to_sym
    self.qty = entry[:catch_qty][:qty] if self.qty != entry[:catch_qty][:qty]
    self.unit = entry[:catch_qty][:unit].to_sym if self.unit != entry[:catch_qty][:unit].to_sym
    self    
  end
  
end