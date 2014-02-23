class TradeStreamController < ApplicationController

  def exchange
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

  def market
    @market = Market.friendly.find(params[:market])

    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new

    redis.subscribe("market_#{@market.id}_trades.create") do |on|
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

  def exchange_market
    @exchange = Exchange.friendly.find(params[:exchange])
    @market = Market.friendly.find(params[:market])

    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new

    redis.subscribe("exchange_#{@exchange.id}_market_#{@market.id}_trades.create") do |on|
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
