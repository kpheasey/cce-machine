class Orders::CryptsyWorker
  include Sidekiq::Worker

  def perform(exchange_market_id, source_sell_orders, source_buy_orders)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    new_orders = []

    source_sell_orders.each do |source_sell|
      new_orders << Order::Sell.create!(
          market: exchange_market.market,
          exchange: exchange_market.exchange,
          price: source_sell['price'],
          amount: source_sell['quantity']
      )
    end

    source_buy_orders.each do |source_buy|
      new_orders << Order::Buy.create!(
          market: exchange_market.market,
          exchange: exchange_market.exchange,
          price: source_buy['price'],
          amount: source_buy['quantity']
      )
    end

    Order.where(exchange: exchange_market.exchange, market: exchange_market.market).
        where('id NOT IN (?)', new_orders.map{ |o| o.id }).delete_all
  end

end
