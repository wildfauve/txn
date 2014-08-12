class Api::V1::OrderTransactionsController < Api::ApplicationController
  
  def index
    @account = Account.find(params[:transaction_account_id])
    @orders = Order.get_orders(account: @account, query: params[:symbol])
    respond_to do |f|
      f.json
    end
  end
  
end