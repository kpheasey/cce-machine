class SwitchVcxHighLowTickers < ActiveRecord::Migration
  def change
    Exchange::VIRCUREX.first.tickers.each do |tick|
      high_temp = tick.high
      tick.high = tick.low
      tick.low = high_temp
      tick.save
    end
  end
end
