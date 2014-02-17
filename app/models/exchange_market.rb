class ExchangeMarket < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  has_many :fees

  accepts_nested_attributes_for :fees

  def current_value
    Trade.where(market: self.market, exchange: self.exchange).order('date DESC').limit(1).first.price
  end
end
