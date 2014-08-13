class Transaction
  
  TXN_OP = {buy: :add_to_holdings, sell: :remove_from_holdings}
  
  attr_accessor :acct
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  
  field :state, type: Symbol
  field :type, type: Symbol
  field :client_id, type: BSON::ObjectId
  field :account_id, type: BSON::ObjectId
  
  embedded_in :order
  
  
  def self.create_txn(type: nil, client: nil)
    txn = self.new
    txn.client_id = client.id    
    txn.state = :initiated
    txn.type = type
    txn
  end
  
  def execute
    #self.send(self.type)
    @acct = self.client.send(TXN_OP[self.type], stocks: self.order.stock_entries)
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