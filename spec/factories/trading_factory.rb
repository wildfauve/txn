FactoryGirl.define do
  factory :account do
    factory :buy_client do
      client_number "12345"
    end
    factory :sell_client do
      client_number "98765"      
    end
  end
  
  factory :stock do
    symbol "blank"
  end
  
end