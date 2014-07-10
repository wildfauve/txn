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
  json.status do
    json.status_code "txn_failed_trade"
    json.status_desc "The trade has failed due to bad data"
    json.messages do
      if @trade.order.messages
        json.order do
          @trade.order.messages.each do |field, error|
            json.set! field, error
          end          
        end
      end
      if @trade.order.stock_entries.any? {|e| e.errors.any?}
        json.stocks do
          @trade.order.stock_entries.each do |se|
            if se.errors.any?
              se.errors.messages.each do |field, error|
                json.set! field, error
              end
            end
          end
        end
      end
    end    
  end
end
json._links do
  json.self do 
    json.href api_v1_trades_quota_holding_path(@trade.order)
  end
end