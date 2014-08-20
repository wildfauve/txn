class Api::V1::EntitlementsController < Api::ApplicationController
  
  def index
    @client = Client.find(params[:transaction_account_id])
    entitle_mgr = EntitlementManager.new
    entitle_mgr.subscribe(self)
    entitle_mgr.entitlement_position(client: @client, params: params)
  end
  
  def validated_entitlements(entitles)
    @entitles = entitles
    render 'index'
  end
  
end