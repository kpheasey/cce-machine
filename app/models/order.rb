class Order < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange

  scope :latest, -> { where(set: Order.maximum(:set)) }
end
