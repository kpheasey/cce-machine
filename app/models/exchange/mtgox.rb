require 'mtgox'

class Exchange::MTGOX < Exchange

  # fetch past trades
  def fetch_trades
    self.exchange_markets.each do |exchange_market|
      max_known_id = Trade.where(exchange: self, market: exchange_market.market).maximum(:exchange_trade_id)

      MtGox.trades.each do |source|
        next if source.id <= max_known_id

        trade = Trade.find_or_initialize_by(
            exchange: self,
            market: exchange_market.market,
            exchange_trade_id: source.id
        )

        trade.price = source.price
        trade.amount = source.amount
        trade.date = source.date
        trade.save
      end
    end
  end

  def fetch_orders(set = nil)
    self.exchange_markets.each do |exchange_market|
      new_orders = []

      MtGox.asks.each do |source_ask|
        new_orders << Order::Sell.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_ask.price,
            amount: source_ask.amount
        )
      end

      MtGox.bids.each do |source_bid|
        new_orders << Order::Buy.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_bid.price,
            amount: source_bid.amount
        )
      end

      Order.where(exchange: self, market: exchange_market.market).
          where('id NOT IN (?)', new_orders.map{ |o| o.id }).destroy_all
    end
  end

end
