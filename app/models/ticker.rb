class Ticker < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :market
end
