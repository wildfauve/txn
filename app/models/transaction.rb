class Transaction
  
  TXN_OP = { buy:  {assign_quota: :add_to_holdings, quota_transfer: :add_to_holdings, transfer_entitlements: :add_to_entitlements },
             sell: {quota_transfer: :remove_from_holdings, transfer_entitlements: :remove_from_entitlements }
           }
  
  attr_accessor :acct
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :state, type: Symbol
  field :type, type: Symbol
  field :order_type, type: Symbol
  field :client_id, type: BSON::ObjectId
  field :account_id, type: BSON::ObjectId
  
  embedded_in :order
  
  
  def self.create_txn(type: nil, order_type: nil, client: nil)
    txn = self.new
    txn.client_id = client.id    
    txn.state = :initiated
    txn.type = type
    txn.order_type = order_type
    txn
  end
  
  def execute(stocks: nil)
    #self.send(self.type)
    @acct = self.client.send(TXN_OP[self.type][self.order_type], stocks: stocks, transaction: self)
    self.account_id = @acct.id
    if @acct.valid?
      self.state = :performed
    else
      self.state = :failed
    end 
    self       
  end
  
  
  def client
    Client.find(self.client_id)
  end
  
end