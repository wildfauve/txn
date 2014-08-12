class DeemedValue
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :period, type: Date
  field :stock_symbol, type: Symbol
  field :stock_id, type: BSON::ObjectId
    
  belongs_to :account

  embeds_many :dv_position_points
  
  def self.create_deemed_value(qty: nil, stock: nil, account: nil)
    dv = self.where(stock_id: stock.id).first
    if dv
      dv.update_dv(qty: qty, stock: stock)
    else
      dv = self.new
      dv.create_dv(qty: qty, stock: stock, account: account)
    end
    dv
  end
  
  def create_dv(qty: nil, stock: nil, account: nil)
    self.account = account
    self.stock_symbol = stock.symbol
    self.stock_id = stock.id
    self.dv_position_points << DvPositionPoint.create_point(qty: qty, value: calc_value(symbol: stock.symbol, qty: qty))
    save
    self
  end
  
  def update_dv(qty: nil, stock: nil)
    self.dv_position_points << DvPositionPoint.create_point(qty: qty, value: calc_value(symbol: stock.symbol, qty: qty))    
    self.save!
    self
  end
  
  def calc_value(symbol: nil, qty: nil)
    dv = DeemedValueRef.get_by_symbol(symbol: symbol)
    dv.interim_dv * qty
  end
    

end