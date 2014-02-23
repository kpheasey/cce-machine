CryptoCurrencyExchangeMachine::Application.routes.draw do

  # root
  root 'trading_floor#show',
       exchange: (Exchange.method_defined?(:is_default) ? Exchange.default : 1),
       market: (Market.method_defined?(:is_default) ? Market.default : 1)

  # Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Sidekiq
  mount Sidekiq::Web, at: '/sidekiq'

  # Devise
  devise_for :user

  # Charts
  get '/charts/line'
  get '/charts/candlestick'

  # resources
  get '/trading-floor/:exchange/:market', to: 'trading_floor#show', as: 'trading_floor'

  namespace :user do
    resources :exchanges
  end

  # streams
  get '/trade-stream/exchange/:exchange', to: 'trade_stream#exchange'
  get '/trade-stream/market/:market', to: 'trade_stream#market'
  get '/trade-stream/exchange-market/:exchange/:market', to: 'trade_stream#exchange_market'

end
