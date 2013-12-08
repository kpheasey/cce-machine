class Market::MTGOX < Market

  def tick
    response = MtGox.ticker

    ticker = Ticker.new
    ticker.market = self
    ticker.high = response.high
    ticker.low = response.low
    ticker.average = response.avg
    ticker.volume = response.volume
    ticker.buy = response.buy
    ticker.sell = response.sell
    ticker.save

    return ticker
  end

end
