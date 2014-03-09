# Exchange ticker
every 1.minutes, roles: [:ticker] do
  rake 'exchanges:tick'
end

every 1.hours, roles: [:ticker] do
  command 'sudo restart sidekiq'
end