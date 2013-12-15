class ExchangeAccount < ActiveRecord::Base
  belongs_to :company
  belongs_to :exchange

  has_and_belongs_to_many :users
end
