class Trade < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  validates_uniqueness_of :exchange_trade_id, scope: :exchange

  default_scope -> { order('created_at DESC') }
end
