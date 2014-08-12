class Api::V1::DeemedValuesController < Api::ApplicationController
  
  def index
    @account = Account.find(params[:transaction_account_id])
  end
  
end