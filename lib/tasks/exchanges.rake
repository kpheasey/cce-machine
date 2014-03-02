namespace :exchanges do

  desc 'Tick the exchanges, tick a second time in 30 seconds'
  task tick: :environment do
    Exchange.tick
    sleep 30
    Exchange.tick
  end

end
