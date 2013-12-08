namespace :markets do
  task :tick => :environment do
   Market.tick
  end
end