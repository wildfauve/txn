json.account do
  json.client_number = @account.client_number
end
json.order_transactions @orders do |order|
  json.state order.state
  json.type order.order_type
  json.txn_type order.txn_for(@account).try(:type) if order.completed?

  json.stocks order.stock_entries do |ent|
    json.concept_id ent.stock_concept.ref_id
    json.symbol ent.stock_concept.symbol
    json.ordered_qty ent.stock_qty
  end
  json.timestamps do
    order.timestamps.each do |ts|
      json.set! ts.name, ts.timestamp
    end
  end
  if order.failed?
    json.status do
      json.status_code order.errorcode
      json.status_desc order.errormessage
      json.messages do
        
      end
    end
  end  
end
json._links do
  json.self do 
    json.href quota_holdings_api_v1_transaction_account_url(@account)
  end
end