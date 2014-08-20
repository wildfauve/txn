json.kind "entitlements"
json.account do
  json.client_number  @client.client_number
end
json.position_time @entitles.time
json.entitlements @entitles.entitles do |entitle|
  json.symbol entitle.stock_symbol
  json.qty entitle.qty
  json.unit entitle.unit
  json.timestamps do 
    json.assigned_time entitle.assigned_time    
  end
  json.fishing_year entitle.entitlement.period
  json.txn_type entitle.op
  json.txn_operation entitle.txn_op
  json.balance entitle.balance
  json._links do
    if entitle.transaction_id
      json.entitlement_trade do
        json.href api_v1_trades_entitlement_path(entitle.transaction.order)
      end
    end
  end
end