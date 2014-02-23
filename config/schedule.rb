# Exchange ticker
every 30.seconds, roles: [:app] do
  runner 'Exchange.tick'
end