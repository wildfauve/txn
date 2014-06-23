class Order
  
  attr_accessor :account
  
  @@ORDER_TYPES = [:assign_quota]
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :caller_uuid, type: String
  field :client_number, type: String
  field :order_type, type: Symbol
  field :state, type: Symbol
  field :stock_qty, type: Integer
  
  belongs_to :stock
  
  embeds_many :transactions
  
  embeds_many :timestamps

  
  def self.create(trade)
    order = self.new
    order.caller_uuid = trade[:caller_uuid]
    order.client_number = trade[:client_number]
    order.order_type = trade[:order_type].to_sym
    order.state = :placed
    order.timestamps << Timestamp.new_state(state: order.state, name: :order_placed_time)
    order.stock_qty = trade[:stock][:ordered_qty].to_i
    stock = Stock.where(symbol: trade[:stock][:symbol].to_sym).first
    order.stock = stock
    order.save
    order  
  end
  
  def self.get_orders(account: nil)
    self.where(client_number: account.client_number)
    #self.where(client_number: account.client_number).collect {|ord| ord.transactions.where(account_id: account.id) }.flatten
  end
  
  def execute_trade
    self.send(self.order_type)
  end
  
  def assign_quota
    account = find_account(client_number: self.client_number)
    raise if !account
    txn = Transaction.create_txn(type: :buy, account: account)
    self.transactions << txn
    txn.execute
    self.state = :complete
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_completed_time)      
    self.save
  end
  
  def find_account(client_number: nil)
    Account.where(client_number: client_number).first
  end
  
end
