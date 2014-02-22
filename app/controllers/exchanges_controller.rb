class ExchangesController < ApplicationController
  layout 'trading_floor'

  def show
    @current_exchange = Exchange.friendly.find(params[:id])
    @current_market = Market.friendly.find(params[:market])
    @sell_orders = Order::Sell.where(exchange: current_exchange, market: current_market).limit(10)
    @buy_orders = Order::Buy.where(exchange: current_market, market: current_market).limit(10)
  end

end
