class Ticker < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :market

  def self.process(trades)
    exchange_id = trades.first.exchange_id
    market_id = trades.first.market_id
    minutes, hours, days, weeks, months = get_increments(trades)

    minutes.each{ |minute| Ticker::OneMinute.process(minute, exchange_id, market_id) }
    hours.each{ |hour| Ticker::OneHour.process(hour, exchange_id, market_id) }
    days.each{ |day| Ticker::OneDay.process(day, exchange_id, market_id) }
    weeks.each{ |week| Ticker::OneWeek.process(week, exchange_id, market_id) }
    months.each{ |month| Ticker::OneMonth.process(month, exchange_id, market_id) }
  end

  def self.get_increments(trades)
    minutes = []
    hours = []
    days = []
    weeks = []
    months = []

    trades.each do |trade|
      minute = trade.date.beginning_of_minute
      minutes << minute unless minutes.include? minute

      hour = trade.date.beginning_of_hour
      hours << hour unless hours.include? hour

      day = trade.date.beginning_of_day
      days << day unless days.include? day

      week = trade.date.beginning_of_week
      weeks << week unless weeks.include? week

      month = trade.date.beginning_of_month
      months << month unless months.include? month
    end

    return minutes, hours, days, weeks, months
  end

  def calculate(trades)
    self.high = trades.max(:price)
    self.open = trades.last.price
    self.close = trades.first.price
    self.low = trades.min(:price)
    self.volume = trades.sum(:amount)
    self.count = trades.size
  end
end
