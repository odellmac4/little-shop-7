Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :merchants, only: [] do
    resource :dashboard, only: [:show]
    resources :items, only: [:index,:show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show]
    resources :invoice_items, only: [:update]
    resources :bulk_discounts, controller: 'merchant_bulk_discounts', only: [:index, :show, :new]
  end

  namespace :admin do
    get "/", to: "dashboards#index"
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show, :update]
  end
end
