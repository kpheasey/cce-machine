namespace :exchanges do
  task :tick => :environment do
    Exchange.fetch_trades
  end
end