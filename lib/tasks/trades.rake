namespace :trades do

  desc 'Start streaming new trades to redis'
  task start_stream: :environment do
    Trade.on_create do |trade|
      Rails.logger.info "Postrgres-to-Redis: #{trade}"
      $redis.publish('trades.create', trade)
    end
  end

  desc 'Stop streaming new trades'
  task stop_stream: :environment do

  end

end
