class AddDefaults < ActiveRecord::Migration
  def up
    # add default Exchanges
    Exchange.create!(
        type: 'Exchange::BTCE',
        name: 'BTC-E',
        code: 'btce'
    )

    Exchange.create!(
        type: 'Exchange::MTGOX',
        name: 'MT.Gox',
        code: 'mtgox'
    )

    # add default Currencies
    Currency.create!(
        name: 'USD',
        code: 'usd'
    )

    Currency.create!(
        name: 'BTC',
        code: 'btc'
    )

    # add default Market
    Market.create!(
        name: 'BTC/USD',
        source: Currency.find_by(code: 'btc'),
        target: Currency.find_by(code: 'usd')
    )

    # add default ExchangeMarkets
    ExchangeMarket.create!(
        market: Market.find_by(name: 'BTC/USD'),
        exchange: Exchange.find_by(code: 'btce'),
        code: 'btc_usd'
    )

    ExchangeMarket.create!(
        market: Market.find_by(name: 'BTC/USD'),
        exchange: Exchange.find_by(code: 'mtgox'),
        code: 'usd'
    )

  end

  def down
    # remove default Exchanges
    Exchange.find_by(type: 'Exchange::BTCE').destroy
    Exchange.find_by(type: 'Exchange::MTGOX').destroy

    # remove default Currencies
    Currency.find_by(code: 'usd').destroy
    Currency.find_by(code: 'btc').destroy

    # remove default Market
    Market.find_by(name: 'BTC/USD').destroy

    #remove default ExchangeMarkets
    ExchangeMarket.find_by(
        market: Market.find_by(name: 'BTC/USD'),
        exchange: Exchange.find_by(code: 'btce')
    ).destroy

    ExchangeMarket.find_by(
        market: Market.find_by(name: 'BTC/USD'),
        exchange: Exchange.find_by(code: 'mtgox'),
        code: 'usd'
    ).destroy
  end
end
