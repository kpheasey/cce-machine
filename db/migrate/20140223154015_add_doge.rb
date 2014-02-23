class AddDoge < ActiveRecord::Migration
  def up
    Currency.create!(
        name: 'DOGE',
        code: 'doge'
    )

    Market.create!(
        name: 'DOGE/BTC',
        source: Currency.find_by(code: 'doge'),
        target: Currency.find_by(code: 'btc'),
        permalink: 'doge-btc',
        is_default: false,
        is_active: true
    )
  end

  def down
    Market.find_by(name: 'DOGE/BTC').destroy
    Currency.find_by(code: 'doge').destroy
  end
end
