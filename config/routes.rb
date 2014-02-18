CryptoCurrencyExchangeMachine::Application.routes.draw do

  # root
  root 'markets#show', id: (Market.method_defined?(:is_default) ? Market.default : 1)

  # Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Devise
  devise_for :users

  # Charts
  get '/charts/line'
  get '/charts/candlestick'

  # resources
  resources :trades, only: [:index]
  get '/trades/chart-data', to: 'trades#chart_data'

  resources :markets, only: [:index, :show]
  get '/markets/chart-data/:id', to: 'markets#chart_data'

  get '/exchanges/chart-data/:id', to: 'exchanges#chart_data'
  get '/exchanges/:id/:market', to: 'exchanges#show', as: 'exchange'

end
