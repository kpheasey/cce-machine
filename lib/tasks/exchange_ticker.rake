namespace :exchanges do
  task :tick => :environment do
    Exchange.fetch_trades
    Exchange.fetch_orders
  end
end