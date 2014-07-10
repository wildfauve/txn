class Order
  
  attr_accessor :account, :messages
  
  @@ORDER_TYPES = [:assign_quota]
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :caller_uuid, type: String
  field :buyer_client_number, type: String
  field :seller_client_number, type: String  
  field :order_type, type: Symbol
  field :state, type: Symbol
  field :placer_id, type: String
  field :placer_name, type: String
  field :trade, type: Hash
  field :errorcode, type: String
  field :errormessage, type: String

  
  embeds_many :stock_entries
  
  embeds_many :transactions
  
  embeds_many :timestamps
  
  validate :accts_valid, on: :create

  
  def self.create(trade)
    order = self.new.create_me(trade)
    order  
  end
  
  # TODO: Dont need this method
  def self.create_failed_order(trade)
    order = self.new
    order.caller_uuid = trade[:caller_uuid]
    order.buyer_client_number = trade[:buyer_account][:client_number] if trade[:buyer_account]
    order.seller_client_number = trade[:seller_account][:client_number] if trade[:seller_account]
    order.order_type = trade[:order_type].to_sym
    order.state = :failed
    order.placer_id = trade[:placer][:party_id]
    order.placer_name = trade[:placer][:party_name]    
    order.timestamps << Timestamp.new_state(state: order.state, name: :order_failed_time)    
    order.trade = trade
    order.save
    order
  end
  
  def create_me(trade)
    self.caller_uuid = trade[:caller_uuid]
    self.buyer_client_number = trade[:buyer_account][:client_number] if trade[:buyer_account]
    self.seller_client_number = trade[:seller_account][:client_number] if trade[:seller_account]
    @buy_acct = find_account(client_number: self.buyer_client_number)
    @sell_acct = find_account(client_number: self.seller_client_number)
    self.order_type = trade[:order_type].to_sym
    self.state = :placed
    self.placer_id = trade[:placer][:party_id]
    self.placer_name = trade[:placer][:party_name]    
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_placed_time)
    self.stock_entries << StockEntry.create_entries(stocks: trade[:stocks])
    #order.save
    self
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
    if @buy_acct && @sell_acct      
      xfer = {}
      xfer[:buy] = {account: @buy_acct}
      xfer[:sell] = {account: @sell_acct}
      xfer.each {|type, account| self.transactions << Transaction.create_txn(type: type, account: account[:account])}
    
      # TODO: Deal with errors on the buy and sell side
      self.transactions.each {|txn| txn.execute }
    
      self.state = :complete
      self.timestamps << Timestamp.new_state(state: self.state, name: :order_completed_time)    
    end
  end
  
  def find_account(client_number: nil)
    Account.where(client_number: client_number).first
  end
  
  def txn_for(account)
    txn = transactions.where(account_id: account.id)
    txn.empty? ? nil : txn.first
  end
  
  def save_everything
    self.transactions.each {|txn| txn.acct.save}
    self.save
    self
  end
  
  def set_failed_state
    self.state = :failed
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_failed_time)
    @messages = errors.messages.dup
    self.save(validate: false)
    self
  end
  
  def failed?
    self.state == :failed
  end
  
  def completed?
    self.state == :complete
  end
  
  private
  
  def accts_valid
    errors.add(:buyer_client_number, "#{self.buyer_client_number} is not valid") if @buy_acct.nil? 
    errors.add(:seller_client_number, "#{self.seller_client_number} is not valid") if @sell_acct.nil?      
  end
  
end
