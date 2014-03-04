class TradeStreamController < ApplicationController
  include ActionController::Live

  def exchange
    @exchange = Exchange.friendly.find(params[:exchange])

    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new

    redis.subscribe(["exchange_#{@exchange.id}_trades.create", 'heartbeat']) do |on|
      on.message do |event, trade|
        if event == "exchange_#{@exchange.id}_trades.create"
          response.stream.write("event: #{event}\n")
          response.stream.write("data: #{trade}\n\n")
        elsif event == 'heartbeat'
          response.stream.write("event: heartbeat\n")
          response.stream.write("data: heartbeat\n\n")
        end
      end
    end
  rescue IOError
    # stream closed
  ensure
    # stopping stream thread
    redis.quit
    response.stream.close
  end

  def market
    @market = Market.friendly.find(params[:market])

    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new

    redis.subscribe(["market_#{@market.id}_trades.create", 'heartbeat']) do |on|
      on.message do |event, trade|
        if event == "market_#{@market.id}_trades.create"
          response.stream.write("event: #{event}\n")
          response.stream.write("data: #{trade}\n\n")
        elsif event == 'heartbeat'
          response.stream.write("event: heartbeat\n")
          response.stream.write("data: heartbeat\n\n")
        end
      end
    end
  rescue IOError
    # stream closed
  ensure
      # stopping stream thread
    redis.quit
    response.stream.close
  end

  def exchange_market
    @exchange = Exchange.friendly.find(params[:exchange])
    @market = Market.friendly.find(params[:market])

    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new

    redis.subscribe(["exchange_#{@exchange.id}_market_#{@market.id}_trades.create", 'heartbeat']) do |on|
      on.message do |event, trade|
        if event == "exchange_#{@exchange.id}_market_#{@market.id}_trades.create"
          response.stream.write("event: #{event}\n")
          response.stream.write("data: #{trade}\n\n")
        elsif event == 'heartbeat'
          response.stream.write("event: heartbeat\n")
          response.stream.write("data: heartbeat\n\n")
        end
      end
    end
  rescue IOError
    # stream closed
  ensure
      # stopping stream thread
    redis.quit
    response.stream.close
  end

end
