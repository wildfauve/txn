json.kind "harvest_return"
json.timestamps do
  json.reporting_period harvest.report_period
  harvest.timestamps.each do |ts|
    json.set! ts.name, ts.timestamp
  end
end
json.state harvest.state
json.catches harvest.harvest_entries do |ent|
  json.stock_code ent.stock_symbol
  json.catch_qty do
    json.unit ent.unit
    json.qty ent.qty
  end
end
json._links do
  json.self do 
    json.href api_v1_harvest_return_path(harvest)
  end
  json.completion do 
    json.href completion_api_v1_harvest_return_path(harvest)
  end      
end      
