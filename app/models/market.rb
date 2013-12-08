class Market < ActiveRecord::Base

  has_many :tickers
  has_many :fees

  accepts_nested_attributes_for :fees, allow_destroy: true

  @@markets = { btce: 'btce', mtgox: 'mtgox' }

  def self.create type
    raise "Bad market type: #{type}" unless @@markets.has_key?(type)
    Market.find_by(name: @@markets[type])
  end

  def self.tick
    Market.all.each do |market|
      market.tick
    end
  end

end