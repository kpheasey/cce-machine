class Orders::BtceWorker
  include Sidekiq::Worker

  def perform(exchange_market_id)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    source_orders = Btce::Depth.new(exchange_market.code).json[exchange_market.code]
    new_orders = []

    source_orders['asks'].each do |source_ask|
      new_orders << Order::Sell.create!(
          market: exchange_market.market,
          exchange: exchange_market.exchange,
          price: source_ask[0],
          amount: source_ask[1]
      )
    end

    source_orders['bids'].each do |source_bid|
      new_orders << Order::Buy.create!(
          market: exchange_market.market,
          exchange: exchange_market.exchange,
          price: source_bid[0],
          amount: source_bid[1]
      )
    end

    Order.where(exchange: exchange_market.exchange, market: exchange_market.market).
        where('id NOT IN (?)', new_orders.map{ |o| o.id }).destroy_all
  end
end