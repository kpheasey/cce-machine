class Chart::Candlestick < Chart

  def initialize(exchanges, market, start_date = nil, end_date = nil, points = nil)
    super
    @exchange = @exchanges.empty? ? nil : @exchanges.first
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

      if @exchange.nil?
        row_data = Trade.where(market_id: @market.id).where('date < ? AND date >= ?', start_time, end_time)
      else
        row_data = Trade.where(exchange_id: exchange.id, market_id: @market.id).where('date < ? AND date >= ?', start_time, end_time)
      end

      next if row_data.empty?

      row << { v: row_data.max_by(&:price).price, f: nil }
      row << { v: row_data[-1].price, f: nil }
      row << { v: row_data[0].price, f: nil }
      row << { v: row_data.min_by(&:price).price, f: nil }

      data[:rows] << { c: row }
      start_time = end_time
    end

    return data
  end

end
