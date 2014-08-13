class Api::V1::TransactionAccountsController < Api::ApplicationController
  
  def index
    @clients = Client.all
    respond_to do |f|
      f.json
    end
    
  end
  
  def quota_holdings
    @client = Client.find(params[:id])
    @account = @client.get_account_by_type(acct_type: :share)
    respond_to do |f|
      f.json {render '/api/v1/quota_holdings/index'}
    end
  end
  
  
end