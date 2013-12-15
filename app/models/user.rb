class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable, :lockable, :timeoutable

  belongs_to :company

  has_many :exchanges, through: :exchange_accounts
  has_many :user_wallets
  has_many :wallets, through: :user_wallets

  has_and_belongs_to_many :exchange_accounts

end