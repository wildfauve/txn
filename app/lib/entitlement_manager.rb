class EntitlementManager
  
  
  def allocate_ace_at_period_start
    Client.with_quota.each do |client|
      puts "Processing Client: #{client.client_name}"
      client.convert_quota_to_ace(entitlement_date: :start_of_period, entitle_algorithm: EntitlementAlgorithm.new)
    end
    true
  end
  
  def entitlement_position(client: nil, params: nil)
    entitle = client.entitlement_positions.on(params[:on_date]).for(:all)
  end
  
end