class Trades::BtceWorker
  include Sidekiq::Worker

  def perform(exchange_market_id)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    max_known_id = Trade.where(exchange: exchange_market.exchange, market: exchange_market.market).maximum(:exchange_trade_id)

    Btce::Trades.new(exchange_market.code, { limit: 2000 }).json[exchange_market.code].each do |source|
      next if source['tid'] <= max_known_id

      trade = Trade.find_or_initialize_by(
          exchange: exchange_market.exchange,
          market: exchange_market.market,
          exchange_trade_id: source['tid']
      )

      trade.price = source['price']
      trade.amount = source['amount']
      trade.date = DateTime.strptime(source['timestamp'].to_s,'%s')
      trade.save
    end
  end
end