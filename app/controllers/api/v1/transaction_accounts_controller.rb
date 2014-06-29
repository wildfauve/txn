class Api::V1::TransactionAccountsController < Api::ApplicationController
  
  def quota_holdings
    @account = Account.find(params[:id])
    respond_to do |f|
      f.json {render '/api/v1/quota_holdings/index'}
    end
  end
  
  
end