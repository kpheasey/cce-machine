class CreateMarket < ActiveRecord::Migration
  def up
    create_table :markets do |t|
      t.string :type
      t.string :name
      t.string :code
    end

    btce = Market::BTCE.new
    btce.name = 'BTC-E'
    btce.code = 'btce'
    btce.save

    mtgox = Market::MTGOX.new
    mtgox.name = 'MT.Gox'
    mtgox.code = 'mtgox'
    mtgox.save
  end

  def down
    drop_table :markets
  end
end
