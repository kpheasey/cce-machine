class Exchange::BTCE < Exchange

  def fetch_trades

    self.exchange_markets.each do |exchange_market|
      source_trades = Btce::Trades.new(exchange_market.code, { limit: 2000 }).json[exchange_market.code]
      known_trades = self.trades.where(market: exchange_market.market).pluck(:exchange_trade_id)
      unknown_trades = []

      source_trades.each do |source|
        unless known_trades.include? source['tid']
          unknown_trades << source
        end
      end

      unknown_trades.each do |source|
        trade = Trade.find_or_initialize_by(
            exchange: self,
            market: exchange_market.market,
            exchange_trade_id: source['tid']
        )
        trade.price = source['price']
        trade.amount = source['amount']
        trade.save
      end
    end
  end

end
