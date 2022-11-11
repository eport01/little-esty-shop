Rails.application.routes.draw do
  get '/', to: "application#welcome"

  resources :merchants do 
    resources :items 
    #creates routes for merchants and merchant_items 
    resources :invoices
    resources :bulk_discounts 
  end
  

  resources :invoice_items


  # get '/admin', to: 'dashboards#index'
  namespace :admin do 
    resources :merchants
    resources :invoices
  end
  
  # got error: "No route matches [GET] "/admin; thus created this-
  get '/admin', to: 'admin/dashboards#index'
  
  # patch 'admin/invoices/:id', to: 'admin/invoices#update'


  #creates routes for merchants and merchant_items 
  get 'merchants/:id/dashboard', to: 'merchant_dashboards#show'
  
end
