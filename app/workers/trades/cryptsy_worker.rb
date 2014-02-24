class Trades::CryptsyWorker
  include Sidekiq::Worker

  def perform(exchange_market_id, source_trades)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    max_known_id = exchange_market.max_id
    last_trade = nil

    source_trades.each do |source_trade|
      next if source_trade['id'].to_i <= max_known_id

      trade = Trade.find_or_initialize_by(
          exchange: exchange_market.exchange,
          market: exchange_market.market,
          exchange_trade_id: source_trade['id']
      )

      trade.price = source_trade['price']
      trade.amount = source_trade['quantity']

      trade.date = Time.strptime("#{source_trade['time']}+00:00", '%Y-%m-%d %H:%M:%S%z').in_time_zone('Eastern Time (US & Canada)')
      trade.save

      last_trade = trade
    end

    last_trade.notify_latest unless last_trade.nil?
  end

end