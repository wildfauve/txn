class Transaction
  
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
    self.send(self.type)
  end
  
  def buy
    buy_txn = self.account.add_to_holdings(stock: self.order.stock, qty: self.order.stock_qty)
    if buy_txn
      self.state = :performed
    else
      self.state = :failed
    end
    
  end
  
  def account
    Account.find(self.account_id)
  end
  
end