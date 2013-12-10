class Exchange::MTGOX < Exchange

  def tick
    self.exchange_markets.each do |exchange_market|
      MtGox.configure do |c|
        c.currency = exchange_market.code.to_sym
      end

      response = MtGox.ticker

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
