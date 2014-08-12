json.account do
  json.client_number = @account.client_number
end
json.holdings @account.holdings do |h|
  json.stock_symbol h.stock_symbol
  json.qty h.qty
end
json._links do
  json.self do 
    json.href quota_holdings_api_v1_transaction_account_path(@account)
  end
  json.order_transactions do 
    json.href api_v1_transaction_account_order_transactions_path(@account)
  end  
end