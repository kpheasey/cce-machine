class Exchange::BTCE < Exchange

  def tick
    response = Btce::Ticker.new 'btc_usd'

    ticker = Ticker.new
    ticker.market = self
    ticker.high = response.high
    ticker.low = response.low
    ticker.average = response.avg
    ticker.volume = response.vol
    ticker.buy = response.buy
    ticker.sell = response.sell
    ticker.save

    return ticker
  end

end
