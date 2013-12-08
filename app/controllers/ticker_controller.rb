class TickerController < ApplicationController

  def index
    @markets = Market.all
  end

  def chart_data
    data = {
        cols: [
            { id: '', label: 'Time', pattern: '', type: 'datetime' }
        ],
        rows: []
    }

    Market.all.each do |market|
      data[:cols] << { id: '', label: market.name, pattern: '', type: 'number'}
    end

    start_time = Time.now
    12.times do
      end_time = start_time - 30.minutes
      row = [ { v: "Date(#{start_time.year}, #{start_time.month}, #{start_time.day}, #{start_time.hour}, #{start_time.min}, #{start_time.sec})", f: nil} ]

      Market.all.each do |market|
        avg = market.tickers.where('tickers.created_at <= ? AND tickers.created_at >= ?', start_time, end_time).average('tickers.average')
        row << { v: avg, f: nil}
      end

      data[:rows] << { c: row }

      start_time = end_time
    end

    render json: data.to_json
  end

end
