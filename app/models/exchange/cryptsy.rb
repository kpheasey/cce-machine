class Exchange::CRYPTSY < Exchange

  attr_reader :api

  # fetch trades and orders
  def tick
    exchange_market_codes = self.exchange_markets.pluck(:code)

    api.marketdata['return']['markets'].each do |market|
      next unless exchange_market_codes.include? market[1]['marketid']

      exchange_market = self.exchange_markets.find_by(code: market[1]['marketid'])
      Trades::CryptsyWorker.perform_async(exchange_market.id, market[1]['recenttrades'])
      #Orders::CryptsyWorker.perform_async(exchange_market.id, market[1]['sellorders'], market[1]['buyorders'])
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
