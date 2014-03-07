# Exchange ticker
every 1.minutes, roles: [:ticker] do
  rake 'exchanges:tick'
end