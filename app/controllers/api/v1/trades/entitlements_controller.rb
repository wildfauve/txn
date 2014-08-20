class Api::V1::Trades::EntitlementsController < Api::ApplicationController
  
  def index
    
  end
  
  def create
    trade = TradingManager.new(params)
    trade.subscribe(self)        
    trade.execute
  end
  
  
  def show
    @trade = TradingManager.get_trade_status(trade_id: params[:id])
    respond_to do |f|
      f.json { render 'show' }
    end    
  end
  
  def trade_accepted(trade)
    @trade = trade
    respond_to do |f|
      f.json { render 'api/v1/trades/shared/create', status: :accepted, location: api_v1_trades_entitlements_path(@trade.order) }
    end
  end

  def trade_failed(trade)
    @trade = trade
    respond_to do |f|
      f.json { render 'api/v1/trades/shared/create', status: :unprocessable_entity, location: api_v1_trades_entitlements_path(@trade.order) }
    end
  end
  
  
end