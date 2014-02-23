class TradingFloorController < ApplicationController

  def show
    @current_exchange = Exchange.friendly.find(params[:exchange])
    @current_market = Market.friendly.find(params[:market])
    @sell_orders = Order::Sell.where(exchange: current_exchange, market: current_market).limit(10)
    @buy_orders = Order::Buy.where(exchange: current_market, market: current_market).limit(10)
  end

  def stream
    @exchange = Exchange.friendly.find(params[:exchange])

    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new

    redis.subscribe("exchange_#{@exchange.id}_trades.create") do |on|
      on.message do |event, trade|
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{trade}\n\n")
      end
    end
  rescue IOError
    # stream closed
  ensure
    redis.quit
    response.stream.close
  end

end
