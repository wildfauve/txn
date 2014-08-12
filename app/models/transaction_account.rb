class TransactionAccount
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :type, type: Symbol
  field :name, type: String

  embeds_many :holdings
  
  has_many :harvest_returns
  
  has_many :deemed_values
  
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
    holding = self.holdings.where(stock_symbol: stock_entry.stock_concept.symbol).first
    if !holding
      holding = StockHolding.create_holding(stock_entry: stock_entry) if !holding
      self.holdings << holding
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