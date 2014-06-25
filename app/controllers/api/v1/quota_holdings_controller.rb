class Api::V1::QuotaHoldingsController < Api::ApplicationController
  
  def index
    @account = Account.where(client_number: params[:client_number]).first
    respond_to do |f|
      f.json
    end
  end
  
  
end