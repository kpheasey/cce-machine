class Exchange::BTCE < Exchange

  # fetch past trades
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
        trade.date = DateTime.strptime(source['timestamp'].to_s,'%s')
        trade.save
      end
    end
  end

  # fetch open orders
  def fetch_orders(set = nil)
    if set.nil?
      set = Order.where(exchange: self, market: exchange_market.market).maximum(:set) || 0
      set = set + 1
    end

    self.exchange_markets.each do |exchange_market|
      orders = Btce::Depth.new(exchange_market.code).json[exchange_market.code]

      orders['asks'].each do |source_ask|
        Order::Ask.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_ask[0],
            amount: source_ask[1],
            set: set
        )
      end

      orders['bids'].each do |source_bid|
        Order::Bid.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_bid[0],
            amount: source_bid[1],
            set: set
        )
      end
    end
  end

end
