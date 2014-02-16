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
    if set.nil?
      set = Order.where(exchange: self, market: exchange_market.market).maximum(:set) || 0
      set = set + 1
    end

    self.exchange_markets.each do |exchange_market|
      MtGox.asks.each do |source_ask|
        Order::Ask.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_ask.price,
            amount: source_ask.amount,
            set: set
        )
      end

      MtGox.bids.each do |source_bid|
        Order::Bid.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_bid.price,
            amount: source_bid.amount,
            set: set
        )
      end
    end
  end

end
