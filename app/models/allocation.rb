class Allocation
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :stock_symbol, type: Symbol
  field :qty, type: Integer, default: 0
  field :unit, type: Symbol
  field :assigned_time, type: Time
  field :op, type: Symbol
  field :balance, type: Integer, default: 0
  field :txn_op, type: Symbol
  field :transaction_id, type: BSON::ObjectId
  
  embedded_in :entitlement
  
  # {:stock_symbol=>:hor9, :units=>:kg, :fish_year_month=>10, :entitle_qty=>10000}  
  def self.add_stock_allocation(stock_unit: nil, assign_date: nil, new_balance: nil, txn_op: nil, transaction: nil)
    alloc = self.new(stock_symbol: stock_unit.symbol, qty: stock_unit.stock_qty, 
                    unit: stock_unit.unit, assigned_time: assign_date, balance: new_balance, 
                    op: get_txn_op(transaction: transaction, method: :buy), 
                    txn_op: txn_op, transaction_id: transaction.id)
    alloc
  end
  
  def self.remove_stock_allocation(stock_unit: nil, assign_date: nil, new_balance: nil, txn_op: nil, transaction: nil)
    alloc = self.new(stock_symbol: stock_unit.symbol, qty: stock_unit.stock_qty, 
                    unit: stock_unit.unit, assigned_time: assign_date, balance: new_balance, 
                    op: get_txn_op(transaction: transaction, method: :sell), 
                    txn_op: txn_op, transaction_id: transaction.id)
    alloc
  end
  
  def self.get_txn_op(transaction: nil, method: nil)
    transaction ? transaction.type : method
  end
  
  def transaction
    @txn ||= Order.where('transactions._id' => self.transaction_id).first.transactions.detect {|t| t.id == transaction_id}
  end
  
end