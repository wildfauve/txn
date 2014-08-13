class Entitlement
  
  include Mongoid::Document
  include Mongoid::Timestamps

  field :period, type: Date
  
  belongs_to :transaction_account
  
  embeds_many :allocations
    
    
  def self.create_period(period: nil)
    e = self.new(period: period)
    e
  end
  
  def self.set_query_base(instances: nil)
    @entitlements = instances
    self
  end
  
  def self.for(params)
    if params.is_a? Symbol
      if params == :all
        allocs = []
        @entitlements.each do |entitle|
          entitle.allocations.each {|al| allocs << al}
        end
      end
    end
    allocs
  end
  
  def add(stock_unit: nil, assign_date: nil)
    self.allocations << Allocation.add_stock_allocation(stock_unit: stock_unit, assign_date: assign_date)
    self    
  end
  
  
  
end
