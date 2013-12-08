BtcMarketExchange::Application.routes.draw do
  root 'ticker#index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/ticker/chart-data', to: 'ticker#chart_data'

  resources :ticker

end
