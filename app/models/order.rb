class Order
    
  attr_accessor :account, :messages
  
  @@ORDER_TYPES = [:assign_quota]
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  include Flex::ModelIndexer
  
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
  
  #flex.sync self
  #flex.index = "txn_order_#{Rails.env}"
  #flex.type = "order"

  
  def self.create(trade)
    order = self.new.create_me(trade)
    order  
  end
    
  def create_me(trade)
    self.caller_uuid = trade[:caller_uuid]
    self.buyer_client_number = trade[:buyer_account][:client_number] if trade[:buyer_account]
    @buy_client = find_client(client_number: self.buyer_client_number)
    if trade[:seller_account]
      self.seller_client_number = trade[:seller_account][:client_number] if trade[:seller_account]
      @sell_client = find_client(client_number: self.seller_client_number)      
    end
    self.order_type = trade[:order_type].to_sym
    self.state = :placed
    if trade[:placer]
      self.placer_id = trade[:placer][:party_id]
      self.placer_name = trade[:placer][:party_name]    
    end
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_placed_time)
    self.stock_entries << StockEntry.create_entries(stocks: trade[:stocks])
    #order.save
    self
  end
  
  def self.get_orders(account: nil, query: nil)
    orders = self.or({buyer_client_number: account.client_number}, {seller_client_number: account.client_number})
    if query
      orders.where('stock_entries.symbol' => query.to_sym)
    else
      orders
    end
  end
  
  def execute_trade
    self.send(self.order_type)
  end
  
  def assign_quota
    txn = Transaction.create_txn(type: :buy, order_type: self.order_type, client: @buy_client)
    self.transactions << txn
    txn.execute(stocks: self.stock_entries)
    self.state = :complete
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_completed_time)      
    #self.save
  end
  
  def transfer_entitlements
    perform_transfer()
  end

  def quota_transfer
    perform_transfer()
  end
  
  
  def perform_transfer
    xfer = {}
    xfer[:buy] = {client: @buy_client}
    xfer[:sell] = {client: @sell_client}
    xfer.each {|type, client| self.transactions << Transaction.create_txn(type: type, order_type: self.order_type, client: client[:client])}
  
    # TODO: Deal with errors on the buy and sell side
    self.transactions.each {|txn| txn.execute(stocks: self.stock_entries) }
  
    self.state = :complete
    self.timestamps << Timestamp.new_state(state: self.state, name: :order_completed_time)    
  end
  
  def find_client(client_number: nil)
    Client.where(client_number: client_number).first
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
  
  def flex_source
    { 
      order_type: order_type,
      order_state: state,
      timestamps: flex_timestamps,
      stocks: flex_stocks,
      transactions: flex_txns
    }
    
  end
  
  def flex_timestamps
    ti = {}
    self.timestamps.each {|t| ti[t.name] = t.timestamp}
    ti
  end
  
  def flex_stocks
    stks = []
    self.stock_entries.each do |s|
      stks << {
        symbol: s.symbol,
        qty: s.stock_qty,
      }
    end
    stks    
  end
  
  def flex_txns
    txns = []
    self.transactions.each do |t|
      txns << {
        type: t.type,
        state: t.state,
        account: {
          client_number: t.account.client_number,
          client_name: t.account.client_name
        }
      }
    end
    txns
  end
  
  private
  
  def accts_valid
    errors.add(:buyer_client_number, "#{self.buyer_client_number} is not valid") if @buy_client.nil? 
    errors.add(:seller_client_number, "#{self.seller_client_number} is not valid") if @sell_client.nil? && self.order_type != :assign_quota     
  end
  
end
