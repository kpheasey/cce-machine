class Exchange::BTCE < Exchange

  # fetch trades and orders
  def tick
    fetch_trades
    fetch_orders
  end

  # fetch past trades
  def fetch_trades
    exchange_market_codes = self.exchange_markets.pluck(:code).join('-')

    Btce::Trades.new(exchange_market_codes, { limit: 1000 }).json.each do |market_code, trades|
      exchange_market = self.exchange_markets.find_by(code: market_code)
      Trades::BtceWorker.perform_async(exchange_market.id, trades)
    end
  end

  # fetch open orders
  def fetch_orders
    exchange_market_codes = self.exchange_markets.pluck(:code).join('-')

    Btce::Depth.new(exchange_market_codes).json.each do |market_code, orders|
      exchange_market = self.exchange_markets.find_by(code: market_code)
      Orders::BtceWorker.perform_async(exchange_market.id, orders)
    end
  end

end
