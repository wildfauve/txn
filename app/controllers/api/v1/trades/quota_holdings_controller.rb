class Api::V1::Trades::QuotaHoldingsController < Api::ApplicationController
  
  def index
    
  end
  
  def create
    @trade = TradingManager.new(params[:quota_holding])
    @trade.add_subscriber(self)        
    @trade.assign_quota
  end
  
  
  def trade_accepted(trade)
    respond_to do |f|
      f.json { render 'create', :status => :accepted, :location => api_v1_trades_quota_holding_path(@trade.order) }
    end
  end
  
  
end