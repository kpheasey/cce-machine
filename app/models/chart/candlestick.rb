class Chart::Candlestick < Chart

  attr_reader :exchanges_trades, :trades

  def initialize(exchanges, market, start_date = nil, end_date = nil, points = nil)
    super
  end

  def data
    data = {
        cols: [
            { id: '', label: 'Time', pattern: '', type: 'datetime' },
            { id: '', label: 'Low', pattern: '', type: 'number' },
            { id: '', label: 'Opening', pattern: '', type: 'number' },
            { id: '', label: 'Closing', pattern: '', type: 'number' },
            { id: '', label: 'High', pattern: '', type: 'number' }
        ],
        rows: []
    }

    start_time = @end_date
    @points.times do
      end_time = start_time - @interval.seconds
      row = [{ v:"Date(#{start_time.year}, #{start_time.month}, #{start_time.day}, #{start_time.hour}, #{start_time.min}, #{start_time.sec})" }]

      if @exchanges.empty?
        row = market_only_row(row, start_time, end_time)
      elsif @exchanges.length == 1
        row = single_exchange_row(row, start_time, end_time)
      else
        row = multiple_exchange_row(row, start_time, end_time)
      end

      next if row.nil?

      data[:rows] << { c: row }
      start_time = end_time
    end

    return data
  end

  def market_only_row(row, start_time, end_time)
    @trades = Trade.where(market: @market).where('date < ? AND date >= ?', start_time, end_time)

    return nil if @trades.empty?

    row << { v: @trades.max_by(&:price).price, f: nil }
    row << { v: @trades[-1].price, f: nil }
    row << { v: @trades[0].price, f: nil }
    row << { v: @trades.min_by(&:price).price, f: nil }

    return row
  end

  def single_exchange_row(row, start_time, end_time)
    @trades = Trade.where(exchange: @exchanges.first, market: @market).where('date < ? AND date >= ?', start_time, end_time)

    return nil if @trades.empty?

    row << { v: @trades.max_by(&:price).price, f: nil }
    row << { v: @trades[-1].price, f: nil }
    row << { v: @trades[0].price, f: nil }
    row << { v: @trades.min_by(&:price).price, f: nil }

    return row
  end

  def multiple_exchange_row(row, start_time, end_time)
    @trades = Trade.includes(:exchange).where(exchange: @exchanges.first, market: @market).where('date < ? AND date >= ?', start_time, end_time)

    return nil if trades.empty?

    row << { v: average_high_price, f: nil }
    row << { v: average_close_price, f: nil }
    row << { v: average_open_price, f: nil }
    row << { v: average_low_price, f: nil }

    return row
  end

  private

  def average_high_price
    total_high = 0

    @exchanges_trades.each do |exchange_trades|
      total_high += exchange_trades.max_by(&:price).price
    end

    return total_high / @exchanges_trades.length
  end

  def average_close_price
    total_low = 0

    @exchanges_trades.each do |exchange_trades|
      total_low += exchange_trades[-1].price
    end

    return total_low / @exchanges_trades.length
  end

  def average_open_price
    total_open = 0

    @exchanges_trades.each do |exchange_trades|
      total_open += exchange_trades[0].price
    end

    return total_open / @exchanges_trades.length
  end

  def average_low_price
    total_low = 0

    @exchanges_trades.each do |exchange_trades|
      total_low += exchange_trades.min_by(&:price).price
    end

    return total_low / @exchanges_trades.length
  end

  def exchanges_trades
    @exchanges_trades ||= begin
      exchange_trades = {}

      @trades.each do |trade|
        exchange_trades[trade.exchange.name] << trade
      end

      exchange_trades
    end
  end

end
