class HarvestEntry
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_code, type: Symbol
  field :qty, type: Integer
  field :unit, type: Symbol
  
  embedded_in :harvest_return
  
  def self.create_entry(entry: nil)
    e = self.new
    e.stock_code = entry[:stock_code]
    e.qty = entry[:catch_qty][:qty]
    e.unit = entry[:catch_qty][:unit]
    e
  end
  
  def update_entry(entry: nil)
    self.stock_code = entry[:stock_code].to_sym if self.stock_code != entry[:stock_code].to_sym
    self.qty = entry[:catch_qty][:qty] if self.qty != entry[:catch_qty][:qty]
    self.unit = entry[:catch_qty][:unit].to_sym if self.unit != entry[:catch_qty][:unit].to_sym
    self    
  end
  
end