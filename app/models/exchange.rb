class Exchange < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  has_many :companies
  has_many :exchange_accounts, dependent: :destroy
  has_many :exchange_markets, dependent: :destroy
  has_many :fees
  has_many :markets, through: :exchange_markets
  has_many :orders
  has_many :order_sells, class_name: 'Order::Sell', dependent: :destroy
  has_many :order_buys, class_name: 'Order::Buy', dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :users, through: :exchange_accounts

  accepts_nested_attributes_for :fees, allow_destroy: true

  after_save :make_default

  default_scope -> { order(:name) }
  scope :active, -> { where(is_active: true) }
  scope :default, -> { find_by(is_default: true) }

  @@exchanges = { btce: 'btce', mtgox: 'mtgox', cryptsy: 'cryptsy' }

  def self.create type
    raise "Bad market type: #{type}" unless @@exchanges.has_key?(type)
    Exchange.find_by(code: @@exchanges[type])
  end

  def self.tick
    Exchange.all.each do |exchange|
      exchange.tick
    end
  end

  def self.fetch_trades
    Exchange.all.each do |exchange|
      exchange.fetch_trades
    end
  end

  def self.fetch_orders
    Exchange.all.each do |exchange|
      exchange.fetch_orders
    end
  end

  private

  def make_default
    if self.is_default
      Market.where('id != ?', self.id).update_all(is_default: false)
    end
  end

end
