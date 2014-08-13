class TransactionAccount
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :acct_type, type: Symbol
  field :name, type: String

  belongs_to :client

  embeds_many :holdings
  
  has_many :entitlements 
  
  has_many :harvest_returns
  
  has_many :deemed_values
  
  def self.create_a_type(acct_type: nil)
    a = self.new(acct_type: acct_type)
    a
  end
  
  
  def add_to_holdings(stocks: nil)
    stocks.each do |stock_entry|
      holding = get_holding(stock_entry: stock_entry)
      holding.add(qty: stock_entry.stock_qty)
    end
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
  
  
  # [{:stock_symbol=>:hor9, :units=>:kg, :fish_year_month=>10, :entitle_qty=>10000},
  #  {:stock_symbol=>:kic1, :units=>:kg, :fish_year_month=>10, :entitle_qty=>3}]
  def add_to_entitlements(entitle_stock_units: nil, assign_date: nil)
    entitle_stock_units.each do |stock_unit|
      period = determine_period(fish_year_month: stock_unit[:fish_year_month], on: Date.today)
      entitle = get_entitlement(period: period)
      entitle.add(stock_unit: stock_unit, assign_date: determine_assign_date(assign_date: assign_date, period: period))
      entitle.save
    end
    self.save
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
      holding = Holding.create_holding(stock_entry: stock_entry)
      self.holdings << holding
    end
    holding
  end
  
  def get_entitlement(period: nil, create: true)
    entitle = self.entitlements.where(period: period).first
    if !entitle && create
      entitle = Entitlement.create_period(period: period)
      self.entitlements << entitle
    end
    entitle
  end
  
  def initialise_harvest_return(period: nil)
    hr = HarvestReturn.initialise_empty_return(period: period, account: @account)
    self.harvest_returns << hr 
    self.save
    hr
  end
  
  def determine_assign_date(assign_date: nil, period: nil)
    if assign_date == :start_of_period
      return period
    else
      raise
    end
  end
  
  def determine_period(fish_year_month: nil, on: nil)
    on.month < fish_year_month ? yr = on.year - 1 : yr = on.year
    Date.new(yr, fish_year_month, 1)
  end
  
  def date_to_periods(date: nil)
    periods = []
    Stock.all.map(&:fish_year_month).uniq.each {|mth| periods << determine_period(fish_year_month: mth, on: date) }
    periods
  end
  
  def on(date)
    entitlements = []
    date_to_periods(date: date).each do |period| 
      entitle = get_entitlement(period: period, create: false)
      entitlements << entitle unless entitle.nil?
    end
    Entitlement.set_query_base(instances: entitlements)
  end
    
end
