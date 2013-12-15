class CreateExchangeAccounts < ActiveRecord::Migration
  def change
    create_table :exchange_accounts do |t|
      t.string :username
      t.string :key
      t.string :secret
      t.integer :exchange_id
      t.integer :company_id

      t.timestamps
    end
  end
end
