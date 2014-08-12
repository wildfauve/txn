json.deemed_values @account.deemed_values do |dv|
  json.stock_code dv.stock_symbol
  json.deemed_value_qty dv.qty
  json.deemed_value dv.value.format
end