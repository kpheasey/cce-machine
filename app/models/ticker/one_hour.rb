class Ticker::OneHour < Ticker

  def self.process(start_time, exchange_id, market_id)
    trades = trades(start_time, exchange_id, market_id)

    return if trades.empty?

    tick = Ticker::OneHour.find_or_initialize_by(
        exchange_id: exchange_id,
        market_id: market_id,
        timestamp: start_time.beginning_of_hour
    )

    tick.calculate(trades)
    tick.save
  end

  def self.trades(start_time, exchange_id, market_id)
    end_time = start_time.end_of_hour

    trades = Trade.where(exchange_id: exchange_id, market_id: market_id).
        where('date >= ? AND date <= ?', start_time, end_time)

    return trades
  end

end