class Exchange::CRYPTSY < Exchange

  attr_reader :api

  # fetch trades and orders
  def tick
    api.marketdata['return']['markets'].each do |market|
      exchange_market = self.exchange_markets.find_by(code: market[1]['marketid'])
      next if exchange_market.nil?
      puts market[1]['buyorders'].inspect
      Trades::CryptsyWorker.perform_async(exchange_market.id, market[1]['recenttrades'])
      Orders::CryptsyWorker.perform_async(exchange_market.id, market[1]['sellorders'], market[1]['buyorders'])
    end
  end

  # fetch past trades
  def fetch_trades
    api.marketdata['return']['markets'].each do |market|
      exchange_market = exchange.exchange_markets.find_by(code: market[1]['marketid'])
      next if exchange_market.nil?

      Trades::CryptsyWorker.perform_async(exchange_market.id, market[1]['recenttrades'])
    end
  end

  # fetch open orders
  def fetch_orders
    api.marketdata['return']['markets'].each do |market|
      exchange_market = exchange.exchange_markets.find_by(code: market[1]['marketid'])
      next if exchange_market.nil?

      Orders::CryptsyWorker.perform_async(exchange_market.id, market[1]['sellorders'], market[1]['buyorders'])
    end
  end

  def api
    @api ||= Cryptsy::API::Client.new
  end

end
