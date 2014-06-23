Txn::Application.routes.draw do

  namespace :api do
    namespace :v1 do
      namespace :trades do
        resources :quota_holdings
      end
    

      resources :accounts do
        collection do
          resources :quota_holdings, only: [:index]
        end
        member do
          get 'quota_holdings'
        end
        resources :order_transactions
      end
    end
  end  


end
