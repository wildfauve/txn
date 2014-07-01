class Transaction
  
  TXN_OP = {buy: :add_to_holdings, sell: :remove_from_holdings}
  
  attr_accessor :acct
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :state, type: Symbol
  field :type, type: Symbol
  field :account_id, type: BSON::ObjectId
  
  embedded_in :order
  
  def self.create_txn(type: nil, account: nil)
    txn = self.new
    txn.account_id = account.id    
    txn.state = :initiated
    txn.type = type
    txn
  end
  
  def execute
    #self.send(self.type)
    @acct = self.account.send(TXN_OP[self.type], stocks: self.order.stock_entries)
    if @acct.valid?
      self.state = :performed
    else
      self.state = :failed
    end 
    self       
  end
  
  
  def account
    Account.find(self.account_id)
  end
  
end