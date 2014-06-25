json.kind "quota_order"
json.id @trade.order.id.to_s
json.caller_uuid @trade.order.caller_uuid  
json.client_number @trade.order.client_number
json.state @trade.order.state
json.order_type @trade.order.order_type
json.timestamps do 
  @trade.order.timestamps.each do |ts|
    json.set! ts.name, ts.timestamp
  end
end
json.stock do
  json.concept_id @trade.order.stock.ref_id
  json.symbol @trade.order.stock.symbol
  json.ordered_qty @trade.order.stock_qty
end
json._links do
  json.self do 
    json.href api_v1_trades_quota_holding_path(@trade.order)
  end
end