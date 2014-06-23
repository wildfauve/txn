class Api::V1::QuotaHoldingsController < ApplicationController
  
  def index
    @account = Account.where(client_number: params[:client_number]).first
    respond_to do |f|
      f.json
    end
  end
  
  
  def trade_accepted(trade)
    respond_to do |f|
      f.json
    end
  end
  
  
end