class Chart::Line < Chart

  def data
    data = {
        cols: [
            { id: '', label: 'Time', pattern: '', type: 'datetime' }
        ],
        rows: []
    }

    @exchanges.each do |exchange|
      data[:cols] << { id: '', label: exchange.name, pattern: '', type: 'number'}
    end

    start_time = @end_time
    @points.times do
      end_time = start_time - @interval.seconds
      row = [ { v: "Date(#{start_time.year}, #{start_time.month}, #{start_time.day}, #{start_time.hour}, #{start_time.min}, #{start_time.sec})", f: nil} ]

      @exchanges.each do |exchange|
        avg = Trade.where(exchange_id: exchange.id, market_id: @market.id).where('date <= ? AND date >= ?', start_time, end_time).average(:price)
        row << { v: avg, f: nil }
      end

      data[:rows] << { c: row }

      start_time = end_time
    end

    return data
  end

end
