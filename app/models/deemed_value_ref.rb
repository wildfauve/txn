class DeemedValueRef
  include Mongoid::Document
  include Mongoid::Timestamps

# Fishstock,Valid from,Valid to,Interim Deemed Value ($/kg) ,Notice number,schedule number,Notes,Notes  
  field :symbol, type: Symbol
  field :symbol_id, type: BSON::ObjectId
  field :valid_from, type: Date
  field :valid_to, type: Date  
  field :interim_dv_cents, type: Integer # $/KG  

  
  def self.create_dvref(symbol: nil, from: nil, to: nil, dv: nil)
    dvr = self.new
    dvr.create_ref(symbol: symbol, from: from, to: to, dv: dv)
    dvr
  end
  
  def self.get_by_symbol(symbol: nil)
    symbol.class != Symbol ? sym = symbol.downcase.to_sym : sym = symbol
    dvref = self.where(symbol: sym).first
    dvref ? dvref : raise
  end
  
  def create_ref(symbol: nil, from: nil, to: nil, dv: nil)
    stock = Stock.get_by_symbol(symbol: symbol)
    self.symbol = stock.symbol
    self.symbol_id = stock.id
    self.valid_from = Date.parse(from)
    self.valid_to = Date.parse(to) if !to.empty?
    self.interim_dv_cents = (dv.to_f * 100).to_i
    self.save!
    self
  end
  
  def interim_dv(options = {})
    raise ArgumentError, 'The "options" arg must be a Hash' unless options.is_a? Hash
    options[:in] ||= 'NZD'
    self.interim_dv_cents.nil? ? cents = 0 : cents = self.interim_dv_cents
    Money.new(cents, options[:in])
  end
  
  
end