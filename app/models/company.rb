class Company < ActiveRecord::Base
  has_many :exchange_accounts
  has_many :exchanges, through: exchange_accounts
  has_many :users
end
