class AddDefaults < ActiveRecord::Migration
  def up
    # add default Exchange
    Exchange.create!(
        type: 'Exchange::BTCE',
        name: 'BTC-E',
        code: 'btce'
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
  end

  def down
    # remove default Exchanges
    Exchange.find_by(type: 'Exchange::BTCE').destroy

    # remove default Currencies
    Currency.find_by(code: 'usd').destroy
    Currency.find_by(code: 'btc').destroy

    # remove default Market
    Market.find_by(name: 'BTC/USD').destroy

    #remove default ExchangeMarkets
    ExchangeMarket.find_by(
        markets: Market.find_by(name: 'BTC/USD'),
        exchange: Exchange.find_by(code: 'btce')
    ).destroy
  end
end
