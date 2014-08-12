class Api::V1::HarvestReturnsController < Api::ApplicationController
  
  def index
    returns_mgr = ReturnsManager.new(params)
    returns_mgr.subscribe(self)
    returns_mgr.get_returns
  end
  
  def update
    returns_mgr = ReturnsManager.new(params)
    returns_mgr.subscribe(self)
    returns_mgr.submit_return_update
  end

  def completion
    returns_mgr = ReturnsManager.new(params)
    returns_mgr.subscribe(self)        
    returns_mgr.complete_return
  end    

  def returns_saved(returns_mgr)
    @returns_mgr = returns_mgr
    respond_to do |f|
      f.json {render 'update', status: :ok, location: api_v1_harvest_return_path(@returns_mgr.harvest)}
    end
  end

  def returns_listed(returns_mgr)
    @returns_mgr = returns_mgr    
    respond_to do |f|
      f.json {render 'index', status: :ok, location: api_v1_harvest_returns_path}
    end
  end
  
  def completed_return(returns_mgr)
    @returns_mgr = returns_mgr
    respond_to do |f|
      f.json {render 'completion', status: :ok, location: api_v1_harvest_return_path(@returns_mgr.harvest)}
    end
    
  end
  
  
end