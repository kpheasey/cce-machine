class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable, :lockable, :timeoutable

  belongs_to :company

  has_many :user_wallets
  has_many :wallets, through: :user_wallets
end