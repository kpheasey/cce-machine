require 'mtgox'

class Exchange::MTGOX < Exchange

  # fetch past trades
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
        trade.date = source.date
        trade.save
      end
    end
  end

  def fetch_orders
    self.exchange_markets.each do |exchange_market|
      set = Order.where(exchange: self, market: exchange_market.market).maximum(:set) || 1

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
