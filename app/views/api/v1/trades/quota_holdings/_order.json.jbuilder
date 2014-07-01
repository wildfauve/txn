json.kind "quota_order"
json.id @trade.order.id.to_s
json.caller_uuid @trade.order.caller_uuid  
if @trade.order.buyer_client_number
  json.buyer_account do
    json.client_number @trade.order.buyer_client_number
  end
end
if @trade.order.seller_client_number
  json.seller_account do
    json.client_number @trade.order.seller_client_number
  end
end
json.state @trade.order.state
json.order_type @trade.order.order_type
json.timestamps do 
  @trade.order.timestamps.each do |ts|
    json.set! ts.name, ts.timestamp
  end
end
json.stocks @trade.order.stock_entries do |ent|
  json.concept_id ent.stock_concept.ref_id
  json.symbol ent.stock_concept.symbol
  json.ordered_qty ent.stock_qty
end
json._links do
  json.self do 
    json.href api_v1_trades_quota_holding_path(@trade.order)
  end
end