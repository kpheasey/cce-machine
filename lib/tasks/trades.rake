namespace :trades do

  desc 'Start streaming new trades to redis'
  task start_stream: :environment do
    Trade.on_create do |trade|
      trade_hash = JSON.parse trade

      $redis.publish("exchange_#{trade_hash['exchange_id']}_trades.create", trade)
      $redis.publish("market_#{trade_hash['market_id']}_trades.create", trade)
      $redis.publish("exchange_#{trade_hash['exchange_id']}_market_#{trade_hash['market_id']}_trades.create", trade)
    end
  end

  desc 'Stop streaming new trades'
  task stop_stream: :environment do

  end

end
