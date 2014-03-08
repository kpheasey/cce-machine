class Chart::Candlestick < Chart

  attr_accessor :exchange, :market, :ticks, :start_time, :end_time, :range

  def initialize(exchange, market, start_time, end_time)
    @exchange = exchange
    @market = market
    @start_time = start_time.to_i
    @end_time = end_time.to_i
    @range = @end_time - @start_time
    fetch_trades
  end

  def data
    rows = []

    @ticks.each do |tick|
      rows << [
          (tick.timestamp.to_time.to_i * 1000),
          tick.open.to_f,
          tick.high.to_f,
          tick.low.to_f,
          tick.close.to_f
      ]
    end

    return rows
  end

  private

  def fetch_trades
    Rails.logger.info @range


    case
      # milliseconds * seconds * minutes * hours * days
      when @range <= 1000 * 60 * 60 * 24 * 2 # 2 day or less, use one minute increments
        Rails.logger.info 'here'
        @ticks = Ticker::OneMinute
      when @range <= 1000 * 60 * 60 * 24 * 30 # 30 days or less, use one hour increments
        @ticks = Ticker::OneHour
      when @range <= 1000 * 60 * 60 * 24 * 365 # 1 year or less, use one day increments
        @ticks = Ticker::OneDay
      when @range <= 1000 * 60 * 60 * 24 * 1825 # 5 years or less, use weekly increments
        @ticks = Ticker::OneWeek
      else # more than 5 years, use monthly increments
       @ticks = Ticker::OneMonth
    end

    @ticks = @ticks.where(exchange: @exchange, market: @market).
        where('timestamp >= ? AND timestamp <= ?', Time.at((@start_time / 1000).round), Time.at((@end_time / 1000).round)).
        order('timestamp ASC')
  end

end
