class Api::V1::HarvestReturnsController < Api::ApplicationController
  
  def index
    returns_mgr = ReturnsManager.new(params)
    returns_mgr.add_subscriber(self)
    returns_mgr.get_returns
  end
  
  def update
    returns_mgr = ReturnsManager.new(params)
    returns_mgr.add_subscriber(self)        
    returns_mgr.submit_return_update
  end

  def completion
    returns_mgr = ReturnsManager.new(params)
    returns_mgr.add_subscriber(self)        
    returns_mgr.complete_return
  end    

  def returns_saved(returns_mgr)
    @returns_mgr = returns_mgr
    respond_to do |f|
      f.json
    end
  end

  def returns_listed(returns_mgr)
    @returns_mgr = returns_mgr    
    respond_to do |f|
      f.json
    end
  end
  
  
end