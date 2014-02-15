class Trade < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  default_scope -> { order('created_at DESC') }
end
