class Chart::Candlestick <Chart

  def initialize(exchanges, market, start_date = nil, end_date = nil, points = nil)
    super
    @exchange = @exchanges.first
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

      @exchanges.each do |exchange|
        row_data = Trade.where(exchange_id: exchange.id, market_id: @market.id).where('date <= ? AND date >= ?', start_time, end_time)
        row << { v: row_data.minimum(:price), f: nil }
        row << { v: row_data.last.price, f: nil }
        row << { v: row_data.first.price, f: nil }
        row << { v: row_data.maximum(:price), f: nil }
      end

      data[:rows] << { c: row }
      start_time = end_time
    end

    return data
  end

end
