class EntitlementAlgorithm
  
  def execute(stock: nil, quota: nil)
    tacc = TaccRef.get_total_entitlement(stock: {})
    ((quota.qty.to_f / stock.total_shares) * tacc).to_i
  end
end