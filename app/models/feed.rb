class Feed
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :symbol, type: Symbol
  field :ref_id, type: String
  field :total_shares, type: Integer
  
end