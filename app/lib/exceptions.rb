module Exceptions
  
  class Standard < StandardError 
    attr :errorcode
    
    def intialize
      @errorcode = 1000
    end
  
  end
  
  class NoAccountFound < Standard
    
    def initialize(model)
      @errorcode = 1001
      @model = model
    end
    
    def message
      "No Account could be found for the Trade"
    end
  end
  
  
end