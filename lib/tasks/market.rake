namespace :exchanges do
  task :tick => :environment do
   Market.tick
  end
end