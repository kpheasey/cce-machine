class Fee < ActiveRecord::Base
  belongs_to :market
  belongs_to :exchange
end
