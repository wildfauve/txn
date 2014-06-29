class ReturnsManager

  attr_accessor :account, :harvests, :harvest

  include Publisher

  def initialize(params)
    if params[:id]
      @harvest = HarvestReturn.find(params[:id])
      @account = @harvest.account
      @new_draft = params
    elsif params[:client_number]
      @account = Account.get_by_client_number(client_number: params[:client_number] )
    end
    self
  end
  
  def get_returns     
    @harvests = initialise_gaps(@account.harvest_returns)
    publish(:returns_listed, self)          
  end
  
  def submit_return_update
    @harvest.update_draft(draft: @new_draft)
    publish(:returns_saved, self)      
  end
  
  def complete_return
    @harvest.set_complete
    publish(:completed_return, self)      
  end
  
  def initialise_gaps(current_returns)
    periods = current_returns.collect {|hr| hr.report_period}
    #if there is nothing
    if periods.empty?
      ret = initialise_empty_return(period: todays_period)
    elsif has_gaps?(periods: periods)
      raise
    else
    end
    current_returns
  end
  
  def todays_period
    today = Date.today
    Date.today.day <= 15 ? Date.new(today.year, today.month - 1, 15) : Date.new(today.year, today.month, 15) 
  end
  
  def initialise_empty_return(period: todays_period)
    @account.initialise_harvest_return(period: period)
  end
  
  def has_gaps?(periods:nil)
    # TODO: Fill gaps
    false
  end
  
  
end
