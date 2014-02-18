class ExchangesController < ApplicationController
  layout 'trading_floor'

  def show
    @current_exchange = Exchange.friendly.find(params[:id])
    @current_market = Market.friendly.find(params[:market])
    @asks = Order::Ask.where(exchange: current_exchange, market: current_market).limit(10)
    @bids = Order::Bid.where(exchange: current_market, market: current_market).limit(10)
  end

end
