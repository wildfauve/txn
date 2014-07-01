json.kind "transaction_accounts"
json.accounts @accounts do |acct|
  json.client_number acct.client_number
  json.client_name acct.client_name
  json._links do
    json.self do
      json.href api_v1_transaction_account_url(acct)
    end
  end
end
