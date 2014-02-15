BtcMarketExchange::Application.routes.draw do
  root 'trades#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)

  get '/trades/chart-data', to: 'trades#chart_data'

  resources :trades, only: [:index]

end
