class Exchange::BTCE < Exchange

  # fetch trades and orders
  def tick
    fetch_trades
    fetch_orders
  end

  # fetch past trades
  def fetch_trades
    self.exchange_markets.each do |exchange_market|
      Trades::BtceWorker.perform_async(exchange_market.id)
    end
  end

  # fetch open orders
  def fetch_orders
    self.exchange_markets.each do |exchange_market|
      Orders::BtceWorker.perform_async(exchange_market.id)
    end
  end

end
