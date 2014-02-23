class DestroyMtGox < ActiveRecord::Migration
  def up
    exchange = Exchange.find_by(code: 'mtgox')
    Trade.where(exchange: exchange).destroy_all
    Order.where(exchange: exchange).destroy_all
    exchange.destroy
  end

  def down
    Exchange::MTGOX.create!(
        name: 'MT.Gox',
        code: 'mtgox'
    )

    ExchangeMarket.create!(
        market: Market.find_by(name: 'BTC/USD'),
        exchange: Exchange.find_by(code: 'mtgox'),
        code: 'usd'
    )
  end
end
