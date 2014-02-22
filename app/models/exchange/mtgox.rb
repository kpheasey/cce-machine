require 'mtgox'

class Exchange::MTGOX < Exchange

  def tick
    fetch_trades
    fetch_orders
  end

  # fetch past trades
  def fetch_trades
    self.exchange_markets.each do |exchange_market|
      Trades::MtgoxWorker.perform_async(exchange_market.id)
    end
  end

  def fetch_orders
    self.exchange_markets.each do |exchange_market|
      Orders::MtgoxWorker.perform_async(exchange_market.id)
    end
  end

end
