class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :type
      t.integer :company_id
      t.string :address
      t.integer :currency_id

      t.timestamps
    end
  end
end
