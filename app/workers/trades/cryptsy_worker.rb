class Trades::CryptsyWorker
  include Sidekiq::Worker

  def perform(exchange_market_id, source_trades)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    max_known_id = Trade.where(exchange: exchange_market.exchange, market: exchange_market.market).maximum(:exchange_trade_id)

    source_trades.each do |source_trade|
      next if source_trade['id'] <= max_known_id

      trade = Trade.find_or_initialize_by(
          exchange: exchange_market.exchange,
          market: exchange_market.market,
          exchange_trade_id: source_trade['id']
      )

      trade.price = source_trade['price']
      trade.amount = source_trade['quantity']
      trade.date = source_trade['time']
      trade.save
    end
  end

end