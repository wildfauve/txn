class Api::V1::QuotaHoldingsController < Api::ApplicationController
  
  def index
    @client = Client.where(client_number: params[:client_number]).first
    @account = @client.get_account_by_type(acct_type: :share)
    respond_to do |f|
      f.json
    end
  end
  
  
end