class Exchange < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  has_many :companies
  has_many :exchange_accounts
  has_many :exchange_markets
  has_many :fees
  has_many :markets, through: :exchange_markets
  has_many :orders
  has_many :order_asks, class_name: 'Order::Ask'
  has_many :order_bids, class_name: 'Order::Bid'
  has_many :trades
  has_many :users, through: :exchange_accounts

  accepts_nested_attributes_for :fees, allow_destroy: true

  @@exchanges = { btce: 'btce', mtgox: 'mtgox' }

  def self.create type
    raise "Bad market type: #{type}" unless @@exchanges.has_key?(type)
    Exchange.find_by(code: @@exchanges[type])
  end

  def self.fetch_trades
    Exchange.all.each do |exchange|
      exchange.fetch_trades
    end
  end

  def self.fetch_orders
    set = Order.maximum(:set) || 0
    set = set + 1

    Exchange.all.each do |exchange|
      exchange.fetch_orders(set)
    end
  end

end
