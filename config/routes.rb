Rails.application.routes.draw do
  get '/', to: "application#welcome"

  resources :merchants do 
    resources :items 
    #creates routes for merchants and merchant_items 
    resources :invoices
  end
  

  resources :invoice_items

  namespace :admin do 
    resources :merchants
    resources :invoices, only: [:show, :update]  
  
  end
  # patch 'admin/invoices/:id', to: 'admin/invoices#update'

  #creates routes for merchants and merchant_items 
  get 'merchants/:id/dashboard', to: 'merchant_dashboards#show'
end
