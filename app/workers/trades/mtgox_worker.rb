class Trades::MtgoxWorker
  include Sidekiq::Worker

  def perform(exchange_market_id)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    max_known_id = Trade.where(exchange: exchange_market.exchange, market: exchange_market.market).maximum(:exchange_trade_id)

    MtGox.trades.each do |source|
      next if source.id <= max_known_id

      trade = Trade.find_or_initialize_by(
          exchange: exchange_market.exchange,
          market: exchange_market.market,
          exchange_trade_id: source.id
      )

      trade.price = source.price
      trade.amount = source.amount
      trade.date = source.date
      trade.save
    end

  end
end