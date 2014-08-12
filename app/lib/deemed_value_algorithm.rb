class DeemedValueAlgorithm
  
=begin
Deemed values were a financial penalty that fishers had to pay for catching fish 
without the relevant quota holdings. The Fisheries Amendment Act 1990 required 
that all commercial fishers pay the deemed value on all excess or unauthorised quota 
fish. The deemed values rate for each fish stock was determined prior to the start of 
each fishing season by the Minister and was paid per kilogram of extra fish caught. In 
setting the deemed value rates, the Minister was required to consider the market value 
of the fish, any other benefits the fisher may receive from the fish, and ensure that the 
price would encourage the fishers to land the catch without encouraging further 
harvesting (Section 28ZE of the amended 1983 Fisheries Act). 
Fishers were required to pay the deemed value amounts monthly for any excess fish 
caught (Peacey 2002). But they could have the money paid for the deemed values 
returned to them if they subsequently acquired the quota required to cover their excess 
catch through either leasing or buying the relevant quota.
=end
  
  
  def execute(returns_mgr)
    @holdings = returns_mgr.account.holdings
    @harvests = returns_mgr.account.harvest_returns
    @account = returns_mgr.account
    determine_difference()
  end
  
  def determine_difference
    returns = stock_harvested()
    ace = ace_held()
    returns.each do |sym, qty|
      ace[sym] ? ce = ace[sym] : ce = 0
      over_fish = qty_over_fish(ace: ce, harvest: returns[sym])
      if qty > 0
        DeemedValue.create_deemed_value(qty: over_fish, stock: Stock.get_by_symbol(symbol: sym), account: @account)
      end
    end
  end
  
  def stock_harvested
    returns = {}
    @harvests.each do |harvest| 
      harvest.harvest_entries.each do |entry|
        returns[entry.stock_symbol] ? returns[entry.stock_symbol] += entry.qty : returns[entry.stock_symbol] = entry.qty 
      end
    end
    returns    
  end
  
  def stock_held
    held = @holdings.inject({}) do |i, h|
      i[h.stock_symbol] = h.qty
      i
    end
    held
  end
  
  def ace_held
    {}
  end
  
  def qty_over_fish(ace: nil, harvest: nil)
    harvest > ace ? harvest - ace : 0
  end
  
end