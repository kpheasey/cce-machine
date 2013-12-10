class CreateMarketExchanges < ActiveRecord::Migration
  def change
    create_table :market_exchanges do |t|
      t.integer :market_id
      t.integer :exchange_id
      t.string :code

      t.timestamps
    end
  end
end
