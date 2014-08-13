class Allocation
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_symbol, type: Symbol
  field :qty, type: Integer, default: 0
  field :unit, type: Symbol
  field :date_assigned, type: Date
  
  embedded_in :entitlement
  
  # {:stock_symbol=>:hor9, :units=>:kg, :fish_year_month=>10, :entitle_qty=>10000}  
  def self.add_stock_allocation(stock_unit: nil, assign_date: nil)
    alloc = self.new(stock_symbol: stock_unit[:stock_symbol], qty: stock_unit[:entitle_qty], 
                    unit: stock_unit[:units], date_assigned: assign_date)
    alloc
  end
  
  
end