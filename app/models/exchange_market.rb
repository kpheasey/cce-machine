class ExchangeMarket < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  has_many :fees

  accepts_nested_attributes_for :fees
end
