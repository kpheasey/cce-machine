class DestroyMtGox < ActiveRecord::Migration
  def up
    Exchange.find_by(code: 'mtgox').destroy
  end

  def down
    Exchange.create!(
        type: 'Exchange::MTGOX',
        name: 'MT.Gox',
        code: 'mtgox'
    )

    ExchangeMarket.create!(
        markets: Market.find_by(name: 'BTC/USD'),
        trades: Exchange.find_by(code: 'mtgox'),
        code: 'usd'
    )
  end
end
