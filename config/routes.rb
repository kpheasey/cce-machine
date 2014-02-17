BtcMarketExchange::Application.routes.draw do
  # Friendly Ids
  get 'exchanges/index'
  get 'exchanges/show'
  get 'market/index'
  get 'market/show'

  # root
  root 'trades#index'

  # Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Devise
  devise_for :users

  # resources
  resources :trades, only: [:index]
  get '/trades/chart-data', to: 'trades#chart_data'

  resources :markets, only: [:index, :show]
  get '/markets/chart-data/:id', to: 'markets#chart_data'

  get '/exchanges/chart-data/:id', to: 'exchanges#chart_data'
  get '/exchanges/:id/:market', to: 'exchanges#show', as: 'exchange'

end
