class MarketsController < ApplicationController

  def index

  end

  def show
    @market = Market.find(params[:id])
  end

  def chart_data
    @market = Market.find(params[:id])

    data = {
        cols: [
            { id: '', label: 'Time', pattern: '', type: 'datetime' }
        ],
        rows: []
    }

    Exchange.all.each do |exchange|
      data[:cols] << { id: '', label: exchange.name, pattern: '', type: 'number'}
    end

    start_time = Time.now
    12.times do
      end_time = start_time - 30.minutes
      row = [ { v: "Date(#{start_time.year}, #{start_time.month}, #{start_time.day}, #{start_time.hour}, #{start_time.min}, #{start_time.sec})", f: nil} ]

      Exchange.all.each do |exchange|
        avg = exchange.trades.where(market: @market).where('trades.date <= ? AND trades.date >= ?', start_time, end_time).average('trades.price')
        row << { v: avg, f: nil }
      end

      data[:rows] << { c: row }

      start_time = end_time
    end

    render json: data.to_json
  end

end
