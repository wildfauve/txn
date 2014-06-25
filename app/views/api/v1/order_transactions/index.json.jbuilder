json.account do
  json.client_number = @account.client_number
end
json.order_transactions @orders do |order|
  json.state order.state
  json.type order.order_type
  json.stock do
    json.concept_id order.stock.ref_id
    json.symbol order.stock.symbol
    json.qty order.stock_qty
  end
  json.timestamps do
    order.timestamps.each do |ts|
      json.set! ts.name, ts.timestamp
    end
  end
end
json._links do
  json.self do 
    json.href api_v1_account_order_transactions_url(@account)
  end
end