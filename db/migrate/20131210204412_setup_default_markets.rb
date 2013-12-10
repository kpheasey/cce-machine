class SetupDefaultMarkets < ActiveRecord::Migration
  def change
    usd = Currency.new
    usd.name = 'USD'
    usd.code = 'usd'
    usd.save

    btc = Currency.new
    btc.name = 'BTC'
    btc.code = 'btc'
    btc.save

    btc_usd = Market.new
    btc_usd.name = 'BTC/USD'
    btc_usd.source = btc
    btc_usd.target = usd
    btc_usd.save

    Exchange.all.each do |exchange|
      em = ExchangeMarket.new
      em.market = btc_usd
      em.exchange = exchange
      em.code = 'btc_usd'
      em.save
    end

    Ticker.all.each do |ticker|
      ticker.market = btc_usd
      ticker.save
    end

  end
end
