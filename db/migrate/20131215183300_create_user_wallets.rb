class CreateUserWallets < ActiveRecord::Migration
  def change
    create_table :user_wallets do |t|
      t.integer :user_id
      t.integer :wallet_id

      t.timestamps
    end
  end
end
