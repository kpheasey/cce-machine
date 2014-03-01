# Exchange ticker
every 1.minutes, roles: [:app] do
  runner 'Exchange.tick'
  sleep 30
  runner 'Exchange.tick'
end