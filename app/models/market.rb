class Market < ActiveRecord::Base
  belongs_to :source, class_name: 'Currency'
  belongs_to :target, class_name: 'Currency'

  has_many :exchange_markets
  has_many :exchanges, through: :exchange_markets

  has_and_belongs_to_many :currencies
end