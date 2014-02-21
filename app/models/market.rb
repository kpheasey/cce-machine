class Market < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  belongs_to :source, class_name: 'Currency'
  belongs_to :target, class_name: 'Currency'

  has_many :exchange_markets
  has_many :exchanges, through: :exchange_markets

  has_and_belongs_to_many :currencies

  after_save :make_default

  scope :active, -> { where(is_active: true) }
  scope :default, -> { find_by(is_default: true) }

  def make_default
    if self.is_default
      Market.where('id != ?', self.id).update_all(is_default: false)
    end
  end

  def current_value
    Trade.where(market: self).order('date DESC').limit(1).first.price
  end
end