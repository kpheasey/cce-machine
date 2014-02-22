class Orders::CryptsyWorker
  include Sidekiq::Worker

  def perform(exchange_market_id, source_sell_orders, source_buy_orders)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    new_orders = []

    source_sell_orders.each do |source_ask|
      new_orders << Order::Sell.create!(
          market: exchange_market.market,
          exchange: exchange_market.exchange,
          price: source_ask['price'],
          amount: source_ask['quantity']
      )
    end

    source_buy_orders.each do |source_bid|
      new_orders << Order::Buy.create!(
          market: exchange_market.market,
          exchange: exchange_market.exchange,
          price: source_bid['price'],
          amount: source_bid['quantity']
      )
    end

    Order.where(exchange: exchange_market.exchange, market: exchange_market.market).
        where('id NOT IN (?)', new_orders.map{ |o| o.id }).destroy_all
  end

end
