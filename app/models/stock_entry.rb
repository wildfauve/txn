class StockEntry
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include ActiveModel::Validations
  
  attr_accessor :stock_params
  
  field :stock_qty, type: Integer
  field :stock_id, type: BSON::ObjectId
  field :symbol, type: Symbol
  field :unit, type: Symbol
  field :fish_year_month, type: Integer

  validate :stock_valid, on: :create
  
  embedded_in :order
  
  #[{"concept_id"=>"hok1-nz", "symbol"=>"hor1", "ordered_qty"=>"100", "unit"=>"kg"},
  # {"concept_id"=>"lun-nz", "symbol"=>"kic1", "ordered_qty"=>"10", "unit"=>"kg"}]
  
  def self.create_entries(stocks: nil)
    ent = []
    stocks.each do |stock| 
      s = self.new
      ent << s.create_entry(stock: stock)
    end
    ent
  end
  
  def create_entry(stock: nil)
    @stock_params = stock
    self.symbol = stock[:symbol]
    self.stock_qty = stock[:ordered_qty].to_i
    self.unit = stock[:unit].to_sym
    ref_stock = Stock.where(symbol: stock[:symbol].to_sym).first
    if ref_stock
      self.stock_id = ref_stock.id
      self.fish_year_month = ref_stock.fish_year_month
    else
      raise
    end
    self    
  end
  
  def stock_concept
    return nil if self.stock_id.nil? 
    @concept ||= Stock.find(self.stock_id)
  end
  
  private
  
  def stock_valid
    if !self.stock_id
      errors.add(:symbol, "#{self.symbol} is an invalid Symbol")
      #raise Exceptions::InvalidStock.new(self) 
    end
  end
  
end

