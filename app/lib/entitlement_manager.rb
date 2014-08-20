class EntitlementManager
  
  attr_accessor :entitles, :time
  
  include Wisper::Publisher
  
  def allocate_ace_at_period_start
    Client.with_quota.each do |client|
      puts "Processing Client: #{client.client_name}"
      client.convert_quota_to_ace(entitlement_date: :start_of_period, entitle_algorithm: EntitlementAlgorithm.new)
    end
    true
  end
  
  def entitlement_position(client: nil, params: nil)
    if params[:on_time].present?
      params[:on_time].is_a?(Time) ? @time = params[:on_time] : @time = Time.parse(params[:on_time], Time.now)
    else
      @time = Time.now
    end
    @entitles = client.entitlement_positions.at(@time).for(:all)
    publish(:validated_entitlements, self)
  end
  
end