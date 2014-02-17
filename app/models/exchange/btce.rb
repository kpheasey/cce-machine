class Exchange::BTCE < Exchange

  # fetch past trades
  def fetch_trades
    self.exchange_markets.each do |exchange_market|
      max_known_id = Trade.where(exchange: self, market: exchange_market.market).maximum(:exchange_trade_id)

      Btce::Trades.new(exchange_market.code, { limit: 2000 }).json[exchange_market.code].each do |source|
        next if source['tid'] <= max_known_id

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
  def fetch_orders
    self.exchange_markets.each do |exchange_market|
      source_orders = Btce::Depth.new(exchange_market.code).json[exchange_market.code]
      new_orders = []

      source_orders['asks'].each do |source_ask|
        new_orders << Order::Ask.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_ask[0],
            amount: source_ask[1]
        )
      end

      source_orders['bids'].each do |source_bid|
        new_orders << Order::Bid.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_bid[0],
            amount: source_bid[1]
        )
      end

      Order.where(exchange: self, market: exchange_market.market).
          where('id NOT IN (?)', new_orders.map{ |o| o.id }).destroy_all
    end
  end

end
