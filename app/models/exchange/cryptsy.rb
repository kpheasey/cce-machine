class Exchange::CRYPTSY < Exchange

  attr_reader :api

  def initialize
    @api = Cryptsy::API::Client.new
  end

  # fetch past trades
  def fetch_trades
    self.exchange_markets.each do |exchange_market|
      max_known_id = Trade.where(exchange: self, market: exchange_market.market).maximum(:exchange_trade_id)

      Cryptsy::API::Client.new.marketdata('DOGE')['return']['market'][0]['recenttrades'].each do |source|
        next if source['id'] <= max_known_id

        trade = Trade.find_or_initialize_by(
            exchange: self,
            market: exchange_market.market,
            exchange_trade_id: source['id']
        )

        trade.price = source['price']
        trade.amount = source['quantity']
        trade.date = source['time']
        trade.save
      end
    end
  end

  # fetch open orders
  def fetch_orders
    self.exchange_markets.each do |exchange_market|
      source_orders = @api.orderdata(exchange_market.code)['return'][0]
      new_orders = []

      source_orders['sellorders'].each do |source_ask|
        new_orders << Order::Sell.create!(
            market: exchange_market.market,
            exchange: self,
            price: source_ask[0],
            amount: source_ask[1]
        )
      end

      source_orders['buyorders'].each do |source_bid|
        new_orders << Order::Buy.create!(
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
