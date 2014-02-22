# Exchange ticker
every 1.minute, roles: [:app] do
  runner 'Exchange.tick'
end