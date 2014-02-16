BtcMarketExchange::Application.routes.draw do
  get "exchanges/index"
  get "exchanges/show"
  get "market/index"
  get "market/show"
  root 'trades#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)

  resources :trades, only: [:index]
  get '/trades/chart-data', to: 'trades#chart_data'

  resources :markets, only: [:index, :show]
  get '/markets/chart-data/:id', to: 'markets#chart_data'

  get '/exchanges/chart-data/:id', to: 'exchanges#chart_data'
  get '/exchanges/:id/:market', to: 'exchanges#show', as: 'exchange'

end
