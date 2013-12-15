class Wallet < ActiveRecord::Base
  belongs_to :company
  has_many :user_wallets
  has_many :users, through: :user_wallets
end
