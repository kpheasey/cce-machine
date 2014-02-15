# Exchange ticker
every 1.minute, roles: [:app] do
  rake 'exchanges:tick'
end