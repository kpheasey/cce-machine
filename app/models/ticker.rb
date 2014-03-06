class Ticker < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :market

  def self.process(trades)
    exchange_id = trades.first.exchange_id
    market_id = trades.first.market_id
    minutes, hours, days, months = get_increments(trades)

    minutes.each do |minute|
      Ticker::OneMinute.process(minute, exchange_id, market_id)
    end
  end

  def self.get_increments(trades)
    minutes = []
    hours = []
    days = []
    months = []

    trades.each do |trade|
      minute = trade.date.beginning_of_minute
      minutes << minute unless minutes.include? minute

      hour = trade.date.beginning_of_hour
      hours << hour unless hours.include? hour

      day = trade.date.beginning_of_day
      days << day unless days.include? day

      month = trade.date.month
      months << month unless months.include? month
    end

    return minutes, hours, days, months
  end
end
