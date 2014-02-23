class Market < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  belongs_to :source, class_name: 'Currency'
  belongs_to :target, class_name: 'Currency'

  has_many :exchange_markets, dependent: :destroy
  has_many :exchanges, through: :exchange_markets
  has_many :trades, dependent: :destroy

  after_save :make_default

  default_scope -> { order(:name) }
  scope :active, -> { where(is_active: true) }
  scope :default, -> { find_by(is_default: true) }

  def current_value(exchange = nil)
    if exchange.nil?
      trade = Trade.where(market: self)
    else
      trade = Trade.where(market: self, exchange: exchange)
    end

    trade = trade.order('date DESC').limit(1).first

    unless trade.nil?
      return trade.price
    end
  end

  private

  def make_default
    if self.is_default
      Market.where('id != ?', self.id).update_all(is_default: false)
    end
  end

end