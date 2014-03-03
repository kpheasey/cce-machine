class Trades::BtceWorker
  include Sidekiq::Worker

  def perform(exchange_market_id, source_trades)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    max_known_id = exchange_market.max_id
    last_trade = nil

    source_trades.each do |source|
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

      last_trade = trade
    end

    last_trade.notify_latest unless last_trade.nil?
    Rails.logger.info 'last trade: ' + last_trade.inspect
  end
end