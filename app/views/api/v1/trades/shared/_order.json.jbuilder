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
json.placer do 
  json.placer_id @trade.order.placer_id
  json.placer_name @trade.order.placer_name
end
json.state @trade.order.state
json.order_type @trade.order.order_type
json.timestamps do 
  @trade.order.timestamps.each do |ts|
    json.set! ts.name, ts.timestamp
  end
end
json.stocks @trade.order.stock_entries do |ent|
  json.concept_id ent.stock_concept.try(:ref_id)
  json.symbol ent.symbol
  json.ordered_qty ent.stock_qty
end
if @trade.order.failed?
  json.partial! 'api/v1/shared/error', order: @trade.order
end
json._links do
  json.self do 
    if @trade.order.order_type == :entitlements_transfer
      json.href api_v1_trades_entitlement_path(@trade.order)
    else
      json.href api_v1_trades_quota_holding_path(@trade.order)
    end
  end
end