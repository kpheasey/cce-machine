require 'vircurex'

class Exchange::VIRCUREX < Exchange

  def tick
    api = Vircurex::API.new 'kpheasey'
    rates = api.get_info_for_currency

    self.exchange_markets.each do |exchange_market|
      currency_1 = exchange_market.market.source
      currency_2 = exchange_market.market.target

      next unless rates.has_key?(currency_1.code.upcase)

      market_rate = rates[currency_1.code.upcase]

      next unless market_rate.has_key?(currency_2.code.upcase)

      market_tick = market_rate[currency_2.code.upcase]

      ticker = Ticker.new
      ticker.exchange = self
      ticker.market = exchange_market.market
      ticker.high = market_tick['highest_bid']
      ticker.low = market_tick['lowest_ask']
      ticker.average = (ticker.high + ticker.low) / 2
      ticker.volume = market_tick['volume']
      ticker.buy = market_tick['last_trade']
      ticker.sell = market_tick['last_trade']
      ticker.save
    end
  end

end