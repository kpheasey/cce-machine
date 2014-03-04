$redis = Redis.new

heartbeat_thread = Thread.new do
  while true
    $redis.publish('heartbeat','thump')
    sleep 1.seconds
  end
end

at_exit do
  # not sure this is needed, but just in case
  heartbeat_thread.kill
  $redis.quit
end


