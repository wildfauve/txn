class Client
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :client_number, type: String
  field :client_name, type: String
  field :has_permit, type: Boolean
  
  has_many :transaction_accounts
  
  def self.get_by_client_number(client_number: nil)
    self.where(client_number: client_number).first
    self.transaction_accounts.where(type: :share).first.holdings.count
  end
  
  def self.with_quota
    Client.all.select {|c| c.transaction_accounts.where(acct_type: :share).count > 0}
  end
  
  #def self.create_by_event(event: nil)
  #  account = self.new
  #  account.update({client_number: event["number"], client_name: event["name"], has_permit: event["permit"] })
  #end
  
  def add_to_holdings(stocks: nil)
    acct = get_account_by_type(acct_type: :share)
    acct.add_to_holdings(stocks: stocks)
    #self.save
    acct
  end
  
  def remove_from_holdings(stocks: nil)
    stocks.each do |stock_entry|
      holding = get_holding(stock_entry: stock_entry)
      holding.remove(qty: stock_entry.stock_qty)
    end
    #self.save
    self    
  end
  
  
  def convert_quota_to_ace(entitlement_date: nil, entitle_algorithm: nil)
    entitle_stock = []
    get_account_by_type(acct_type: :share).holdings.each do |h|
      entitle_stock << {stock_symbol: h.stock.symbol, units: h.stock.unit, fish_year_month: h.stock.fish_year_month,
        entitle_qty: entitle_algorithm.execute(stock: h.stock, quota: h)
      }
    end
    add_to_entitlements(entitle_stock_units: entitle_stock, assign_date: entitlement_date)
  end
  
  def add_to_entitlements(entitle_stock_units: nil, assign_date: nil)
    acct = get_account_by_type(acct_type: :entitlement)
    acct.add_to_entitlements(entitle_stock_units: entitle_stock_units, assign_date: assign_date)
  end
  
  def update_by_event(event: nil)
    self.update({client_number: event["number"], client_name: event["name"], has_permit: event["permit"] })    
  end
  
  def update(params)
    self.client_number = params[:client_number]
    self.client_name = params[:client_name]
    self.has_permit = params[:has_permit]
    self.save
  end
  
  def get_holding(stock_entry: nil)
    holding = self.holdings.where(stock_symbol: stock_entry.stock_concept.symbol).first
    if !holding
      holding = StockHolding.create_holding(stock_entry: stock_entry) if !holding
      self.holdings << holding
    end
    holding
  end
  
  def entitlement_positions
    get_account_by_type(acct_type: :entitlement)
  end
  
  def initialise_harvest_return(period: nil)
    hr = HarvestReturn.initialise_empty_return(period: period, account: @account)
    self.harvest_returns << hr 
    self.save
    hr
  end
  
  def get_account_by_type(acct_type: nil)
    acct = self.transaction_accounts.where(acct_type: acct_type).first
    if !acct
      acct = TransactionAccount.create_a_type(acct_type: acct_type)
      self.transaction_accounts << acct
    end
    return acct
  end
  
end