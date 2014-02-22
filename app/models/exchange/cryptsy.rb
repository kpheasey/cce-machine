class Exchange::CRYPTSY < Exchange

  attr_reader :api

  def initialize
    @api = Cryptsy::API::Client.new
  end

  # fetch trades and orders
  def tick
    @api.marketdata['return']['markets'].each do |market|
      exchange_market = exchange.exchange_markets.find_by(code: market['marketid'])
      next if exchange_market.nil?

      Trades::CryptsyWorker.perform_async(exchange_market.id, market['recenttrades'])
      Orders::CryptsyWorker.perform_async(exchange_market.id, market['sellorders'], market['buyorders'])
    end
  end

  # fetch past trades
  def fetch_trades
    @api.marketdata['return']['markets'].each do |source|
      exchange_market = exchange.exchange_markets.find_by(code: market['marketid'])
      next if exchange_market.nil?

      Trades::CryptsyWorker.perform_async(exchange_market.id, market['recenttrades'])
    end
  end

  # fetch open orders
  def fetch_orders
    @api.marketdata['return']['markets'].each do |market|
      exchange_market = exchange.exchange_markets.find_by(code: market['marketid'])
      next if exchange_market.nil?

      Orders::CryptsyWorker.perform_async(exchange_market.id, market['sellorders'], market['buyorders'])
    end
  end

end
