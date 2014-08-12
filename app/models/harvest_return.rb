class HarvestReturn
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :report_period, type: Date
  field :state, type: Symbol
  
  belongs_to :account

  embeds_many :harvest_entries
  embeds_many :timestamps
  
  def self.initialise_empty_return(period: nil, account: nil)
    hr = self.new
    hr.report_period = period
    hr.state = :open
    hr.timestamps << Timestamp.new_state(state: hr.state, name: :initialised_time)
    hr.save
    hr    
  end
  
  
  def update_draft(draft: nil)
    self.timestamps << Timestamp.new_state(state: self.state, name: :updated_time)
    draft[:catches].each do |cat| 
      stock = Stock.get_by_symbol(symbol: cat[:stock_code])
      ent = self.harvest_entries.where(stock_id: stock).first
      ent.nil? ? self.harvest_entries << HarvestEntry.create_entry(entry: cat, stock: stock) : ent.update_entry(entry: cat)
    end
    save
  end
  
  def set_complete
    self.state = :completed
    self.timestamps << Timestamp.new_state(state: self.state, name: :completed_time)
    save
  end

end