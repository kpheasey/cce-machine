class ExchangesController < ApplicationController

  def index

  end

  def show
    @exchange = Exchange.friendly.find(params[:id])
  end

  def chart_data
    @exchange = Exchange.friendly.find(params[:id])
    @market = Market.friendly.find(params[:market])

    data = {
        cols: [
            { id: '', label: 'Time', pattern: '', type: 'datetime' },
            { id: '', label: @market.name, pattern: '', type: 'number'}
        ],
        rows: []
    }

    start_time = Time.now
    12.times do
      end_time = start_time - 30.minutes
      row = [ { v: "Date(#{start_time.year}, #{start_time.month}, #{start_time.day}, #{start_time.hour}, #{start_time.min}, #{start_time.sec})", f: nil} ]

      avg = @exchange.trades.where(market: @market).where('trades.date <= ? AND trades.date >= ?', start_time, end_time).average('trades.price')
      row << { v: avg, f: nil }

      data[:rows] << { c: row }

      start_time = end_time
    end

    render json: data.to_json
  end

end
