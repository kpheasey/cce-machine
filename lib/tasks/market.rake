namespace :exchanges do
  task :tick => :environment do
    Exchange.tick
  end
end