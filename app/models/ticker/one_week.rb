class Ticker::OneWeek < Ticker

  def self.process(start_time, exchange_id, market_id)
    trades = trades(start_time, exchange_id, market_id)

    return if trades.empty?

    tick = Ticker::OneWeek.find_or_initialize_by(
        exchange_id: exchange_id,
        market_id: market_id,
        timestamp: start_time.beginning_of_week
    )

    tick.exchange_id = exchange_id
    tick.market_id = market_id
    tick.high = trades.max_by(&:price).price
    tick.open = trades[-1].price
    tick.close = trades[0].price
    tick.low = trades.min_by(&:price).price
    tick.volume = trades.map(&:amount).inject(0, &:+)
    tick.count = trades.size
    tick.save
  end

  def self.trades(start_time, exchange_id, market_id)
    end_time = start_time.end_of_week

    trades = Trade.where(exchange_id: exchange_id, market_id: market_id).
        where('date >= ? AND date <= ?', start_time, end_time)

    return trades
  end

end