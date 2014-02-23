class AddCryptsy < ActiveRecord::Migration
  def up
    Exchange::CRYPTSY.create!(
        name: 'Cryptsy',
        code: 'cryptsy'
    )

    ExchangeMarket.create!(
        market: Market.find_by(name: 'DOGE/BTC'),
        exchange: Exchange.find_by(code: 'cryptsy'),
        code: '132'
    )
  end

  def down
    ExchangeMarket.find_by(code: 'doge-btc').destroy
    Exchange.find_by(code: 'cryptsy').destroy
  end
end
