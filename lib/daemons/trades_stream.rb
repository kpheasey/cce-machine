#!/usr/bin/env ruby

# You might want to change this
ENV['RAILS_ENV'] ||= 'development'

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, 'config', 'environment')

$running = true
Signal.trap('TERM') do
  $running = false
end

while($running) do

  Trade.on_create do |trade|
    trade_hash = JSON.parse trade

    $redis.publish("exchange_#{trade_hash['exchange_id']}_trades.create", trade)
    $redis.publish("market_#{trade_hash['market_id']}_trades.create", trade)
    $redis.publish("exchange_#{trade_hash['exchange_id']}_market_#{trade_hash['market_id']}_trades.create", trade)
  end

end
