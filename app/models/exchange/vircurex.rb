require 'vircurex'

class Exchange::VIRCUREX < Exchange

  #def self.tick
  #  api = Vircurex::API.new 'kpheasey'
  #  rates = api.get_info_for_currency
  #
  #  self.exchange_markets.each do |exchange_market|
  #
  #    if rates.has_key?(exchange_market.market.source.upcase.to_sym)
  #
  #    ticker = Ticker.new
  #    ticker.exchange = self
  #    ticker.market = exchange_market.market
  #    ticker.high = response.high
  #    ticker.low = response.low
  #    ticker.average = response.avg
  #    ticker.volume = response.vol
  #    ticker.buy = response.buy
  #    ticker.sell = response.sell
  #    ticker.save
  #  end
  #end

end