class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.integer :market_id
      t.decimal :high
      t.decimal :low
      t.decimal :average
      t.decimal :volume
      t.decimal :buy
      t.decimal :sell
      t.timestamps
    end
  end
end
