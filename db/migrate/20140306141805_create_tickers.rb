class CreateTickers < ActiveRecord::Migration
  def up
    create_table :tickers do |t|
      t.string      :type
      t.references  :exchange
      t.references  :market
      t.decimal     :high
      t.decimal     :open
      t.decimal     :close
      t.decimal     :low
      t.decimal     :volume
      t.timestamp   :timestamp

      t.timestamps
    end

    add_index :tickers, [:type, :exchange_id, :market_id]
  end

  def down
    drop_table :tickers
  end
end
