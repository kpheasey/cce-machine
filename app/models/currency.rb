class Currency < ActiveRecord::Base
  has_and_belongs_to_many :markets
end
