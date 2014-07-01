class Order
  
  attr_accessor :account
  
  @@ORDER_TYPES = [:assign_quota]
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :caller_uuid, type: String
  field :buyer_client_number, type: String
  field :seller_client_number, type: String  
  field :order_type, type: Symbol
  field :state, type: Symbol

  
  embeds_many :stock_entries
  
  embeds_many :transactions
  
  embeds_many :timestamps

  
  def self.create(trade)
    order = self.new
    order.caller_uuid = trade[:caller_uuid]
    order.buyer_client_number = trade[:buyer_account][:client_number] if trade[:buyer_account]
    order.seller_client_number = trade[:seller_account][:client_number] if trade[:seller_account]
    order.order_type = trade[:order_type].to_sym
    order.state = :placed
    order.timestamps << Timestamp.new_state(state: order.state, name: :order_placed_time)
    order.stock_entries << StockEntry.create_entries(stocks: trade[:stocks])
    #order.save
    order  
  end
  
  def self.get_orders(account: nil)
    self.or({buyer_client_number: account.client_number}, {seller_client_number: account.client_number})
    #self.where(client_number: account.client_number).collect {|ord| ord.transactions.where(account_id: account.id) }.flatten
  end
  
  def execute_trade
    self.send(self.order_type)
  end
  
  def assign_quota
    account = find_account(client_number: self.buyer_client_number)
    raise Exceptions::NoAccountFound if !account
    txn = Transaction.create_txn(type: :buy, account: account)
    self.transactions << txn
    txn.execute
    self.state = :complete
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_completed_time)      
    #self.save
  end
  
  def transfer_quota
    xfer = {}
    xfer[:buy] = {account: find_account(client_number: self.buyer_client_number)}
    xfer[:sell] = {account: find_account(client_number: self.seller_client_number)}    
    raise Exceptions::NoAccountFound if !xfer[:buy][:account] || !xfer[:sell][:account]
    xfer.each {|type, account| self.transactions << Transaction.create_txn(type: type, account: account[:account])}
    
    # TODO: Deal with errors on the buy and sell side
    self.transactions.each {|txn| txn.execute }
    
    self.state = :complete
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_completed_time)    
  end
  
  def find_account(client_number: nil)
    Account.where(client_number: client_number).first
  end
  
  def txn_for(account)
    transactions.where(account_id: account.id).first
  end
  
  def save_everything
    self.transactions.each {|txn| txn.acct.save}
    self.save
    self
  end
  
end
