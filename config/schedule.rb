# Exchange ticker
every 1.minutes, roles: [:app] do
  rake 'exchanges:tick'
end