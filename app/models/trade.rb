class Trade < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  default_scope -> { order('created_at DESC') }

  scope :latest,  -> { order('created_at DESC').limit(1).first }
end
