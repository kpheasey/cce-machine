CryptoCurrencyExchangeMachine::Application.routes.draw do

  # root
  root 'markets#show', id: (Market.method_defined?(:is_default) ? Market.default : 1)

  # Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Devise
  devise_for :user

  # Charts
  get '/charts/line'
  get '/charts/candlestick'

  # resources
  get '/exchanges/:id/:market', to: 'exchanges#show', as: 'exchange'
  resources :markets, only: [:index, :show]
  get '/trades/stream', to: 'trades#stream'

  namespace :user do
    resources :exchanges
  end

end
