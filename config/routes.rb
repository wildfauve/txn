Txn::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :trades do
        resources :quota_holdings
        resources :entitlements
      end
    

      resources :transaction_accounts do
        collection do
          resources :quota_holdings, only: [:index]
          resources :entitlements, only: [:index]
        end
        member do
          get 'quota_holdings'
        end
        resources :order_transactions
        resources :deemed_values
        resources :entitlements
      end
      resources :harvest_returns do
        member do
          put 'completion'
        end
      end
      
    end
  end  


end
