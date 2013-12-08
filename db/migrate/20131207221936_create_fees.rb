class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :market_id
      t.decimal :min
      t.decimal :max
      t.decimal :fee
      t.decimal :discount
      t.timestamps
    end
  end
end
