class Trades::BtceWorker
  include Sidekiq::Worker

  def perform(exchange_market_id, source_trades)
    exchange_market = ExchangeMarket.includes(:exchange, :market).find(exchange_market_id)
    max_known_id = exchange_market.max_id
    trades = []

    source_trades.each do |source|
      next if source['tid'] <= max_known_id

      trade = Trade.find_or_initialize_by(
          exchange: exchange_market.exchange,
          market: exchange_market.market,
          exchange_trade_id: source['tid']
      )

      new_trade = trade.new_record?

      trade.price = source['price']
      trade.amount = source['amount']
      trade.date = DateTime.strptime(source['timestamp'].to_s,'%s')
      trade.save

      trades << trade if new_trade
    end

    unless trades.empty?
      trades.last.notify_latest unless trades.empty?
      Ticker.process(trades)
    end

  end
end