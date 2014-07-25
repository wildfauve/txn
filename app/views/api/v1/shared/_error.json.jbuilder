json.status do
  json.status_code "txn_failed_trade"
  json.status_desc "The trade has failed due to bad data"
  json.messages do
    if order.messages
      json.order do
        order.messages.each do |field, error|
          json.set! field, error
        end          
      end
    end
    if order.stock_entries.any? {|e| e.errors.any?}
      json.stocks do
        order.stock_entries.each do |se|
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
