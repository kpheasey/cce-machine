require 'mtgox'

class Exchange::MTGOX < Exchange


  def fetch_trades

    self.exchange_markets.each do |exchange_market|
      source_trades = MtGox.trades
      known_trades = self.trades.where(market: exchange_market.market).pluck(:exchange_trade_id)
      unknown_trades = []

      source_trades.each do |source|
        unless known_trades.include? source.id
          unknown_trades << source
        end
      end

      unknown_trades.each do |source|
        trade = Trade.find_or_initialize_by(
            exchange: self,
            market: exchange_market.market,
            exchange_trade_id: source.id
        )
        trade.price = source.price
        trade.amount = source.amount
        trade.save
      end
    end
  end

end
