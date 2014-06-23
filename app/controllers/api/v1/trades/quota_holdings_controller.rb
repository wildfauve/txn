class Api::V1::Trades::QuotaHoldingsController < ApplicationController
  
  def index
    
  end
  
  def create
    @trade = TradingManager.new(params[:quota_holding])
    @trade.add_subscriber(self)        
    @trade.assign_quota
  end
  
  
  def trade_accepted(trade)
    respond_to do |f|
      f.json
    end
  end
  
  
end