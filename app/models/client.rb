class Client
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :client_number, type: String
  field :client_name, type: String
  field :has_permit, type: Boolean

  embeds_many :stock_holdings
  
  has_many :transaction_accounts
  
  def self.get_by_client_number(client_number: nil)
    self.where(client_number: client_number).first
  end
  
  def self.create_by_event(event: nil)
    account = self.new
    account.update({client_number: event["number"], client_name: event["name"], has_permit: event["permit"] })
  end
  
  def add_to_holdings(account_type: nil, stocks: nil)
    stocks.each do |stock_entry|
      holding = get_holding(stock_entry: stock_entry)
      holding.add(qty: stock_entry.stock_qty)
    end
    #self.save
    self
  end
  
  def remove_from_holdings(stocks: nil)
    stocks.each do |stock_entry|
      holding = get_holding(stock_entry: stock_entry)
      holding.remove(qty: stock_entry.stock_qty)
    end
    #self.save
    self    
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
    holding = self.stock_holdings.where(stock_symbol: stock_entry.stock_concept.symbol).first
    if !holding
      holding = StockHolding.create_holding(stock_entry: stock_entry) if !holding
      self.stock_holdings << holding
    end
    holding
  end
  
  def initialise_harvest_return(period: nil)
    hr = HarvestReturn.initialise_empty_return(period: period, account: @account)
    self.harvest_returns << hr 
    self.save
    hr
  end
  
end
