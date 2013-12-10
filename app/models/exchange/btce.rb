class Exchange::BTCE < Exchange

  def tick
    self.exchange_markets.each do |exchange_market|
      response = Btce::Ticker.new exchange_market.code

      ticker = Ticker.new
      ticker.exchange = self
      ticker.market = exchange_market.market
      ticker.high = response.high
      ticker.low = response.low
      ticker.average = response.avg
      ticker.volume = response.vol
      ticker.buy = response.buy
      ticker.sell = response.sell
      ticker.save
    end
  end

end
