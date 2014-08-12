class DvPositionPoint
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :value_cents, type: Integer
  field :qty, type: Integer
  
  embedded_in :deemed_value
  
  
  def self.create_point(qty: nil, value: nil)
    # TODO: Need to check period and stock to determine whether update or new HR.
    point = self.new
    
    point.create_point(qty: qty, value: value)
    point
  end
  
  def create_point(qty: qty, value: value)
    self.qty = qty
    self.value_cents = value.cents
    self
  end
  
  def value(options = {})
    raise ArgumentError, 'The "options" arg must be a Hash' unless options.is_a? Hash
    options[:in] ||= 'NZD'
    self.value_cents.nil? ? cents = 0 : cents = self.value_cents
    Money.new(cents, options[:in])
  end

  
  
end