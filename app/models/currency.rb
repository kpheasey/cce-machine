class Currency < ActiveRecord::Base
  has_many :source_markets, class_name: 'Market', foreign_key: 'source_id'
  has_many :target_markets, class_name: 'Market', foreign_key: 'target_id'
end
