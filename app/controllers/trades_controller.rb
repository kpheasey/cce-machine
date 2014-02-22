class TradesController < ApplicationController
  include ActionController::Live

  def stream
    response.headers['Content-Type'] = 'text/event-stream'
    redis = Redis.new
    redis.subscribe('trades.create') do |on|
      on.message do |event, trade|
        response.stream.write("event: #{event}\n")
        response.stream.write("data: #{trade}\n\n")
      end
    end
  rescue IOError
    logger.info 'Stream closed'
  ensure
    redis.quit
    response.stream.close
  end

end
