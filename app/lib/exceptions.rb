module Exceptions
  
  class FishError < StandardError 
    attr :errorcode, :model
    
    def intialize
      @errorcode = 1000
    end
  
  end
  
  class TradesError < FishError
    @@domain = "Trading"
    
    def domain
      @@domain
    end
    
  end
  
  class NoAccountFound < TradesError
    
    def initialize
      @errorcode = 1001
    end
    
    def message
      "No Account could be found for the Trade"
    end
  end

  class InvalidStock < TradesError
    
    def initialize(stock)
      @stock = stock
      @errorcode = 1001
    end
    
    def message
      "Traded Stock symbol #{@stock.stock_params["symbol"]} is not known"
    end
  end
  
  
end