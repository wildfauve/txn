json.kind "harvest_returns"
json.client_number @returns_mgr.account.client_number
json._embedded do
  json.harvest_returns @returns_mgr.harvests, partial: "harvest", as: :harvest
end