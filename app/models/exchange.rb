class Exchange < ActiveRecord::Base
  has_many :tickers
  has_many :fees
  has_many :exchange_markets
  has_many :markets, through: :exchange_markets

  accepts_nested_attributes_for :fees, allow_destroy: true

  @@exchanges = { btce: 'btce', mtgox: 'mtgox' }

  def self.create type
    raise "Bad market type: #{type}" unless @@exchanges.has_key?(type)
    Exchange.find_by(code: @@exchanges[type])
  end

  def self.tick
    Exchange.all.each do |market|
      market.tick
    end
  end

end
