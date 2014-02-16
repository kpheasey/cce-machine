class Market < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  belongs_to :source, class_name: 'Currency'
  belongs_to :target, class_name: 'Currency'

  has_many :exchange_markets
  has_many :exchanges, through: :exchange_markets
  has_many :fees

  has_and_belongs_to_many :currencies

  accepts_nested_attributes_for :fees
end