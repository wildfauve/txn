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
  
  # Set the instances of Entitlement that will be queried in the self.for method
  def self.set_query_base(instances: nil, on_time: nil)
    @entitlements = instances
    @on_time = on_time
    self
  end
  
  def self.for(params)
    if params.is_a? Symbol
      if params == :all
        allocs = []
        @entitlements.each do |entitle|
          entitle.allocations.lte(assigned_time: @on_time).each {|al| allocs << al}
        end
      else
        raise
      end
    end
    allocs
  end
  
  def add_op(stock_unit: nil, assign_date: nil, txn_op: nil, transaction: nil)
    target_stock = get_target(symbol: stock_unit.symbol)
    target_stock ? balance = target_stock.balance + stock_unit.stock_qty : balance = stock_unit.stock_qty
    self.allocations << Allocation.add_stock_allocation(stock_unit: stock_unit, assign_date: assign_date, new_balance: balance, txn_op: txn_op, transaction: transaction)
    self    
  end
  
  def remove_op(stock_unit: nil, txn_op: nil, assign_date: nil, transaction: nil)
    target_stock = get_target(symbol: stock_unit.symbol)
    target_stock ? balance = target_stock.balance - stock_unit.stock_qty : balance = stock_unit.stock_qty
    self.allocations << Allocation.remove_stock_allocation(stock_unit: stock_unit, assign_date: assign_date, new_balance: balance, txn_op: txn_op, transaction: transaction)
    self    
  end
  
  
  def get_target(symbol: nil)
    target = self.allocations.where(stock_symbol: symbol).asc(:assigned_time).try(:first)
  end
  
  
end
