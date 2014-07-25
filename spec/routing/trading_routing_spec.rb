require "rails_helper"

RSpec.describe Api::V1::Trades::QuotaHoldingsController, :type => :routing do
  describe "routing" do


    it "routes to #show" do
      expect(:get => "api/v1/trades/quota_holdings/1").to route_to("api/v1/trades/quota_holdings#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/v1/trades/quota_holdings").to route_to("api/v1/trades/quota_holdings#create")
    end

  end
end
