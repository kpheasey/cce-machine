class TradingFloorController < ApplicationController
  layout 'trading_floor'
  before_action :validate_exchange_market, only: :show

  def show
    @sell_orders = Order::Sell.where(exchange: current_exchange, market: current_market).limit(10)
    @buy_orders = Order::Buy.where(exchange: current_market, market: current_market).limit(10)
  end

  private

  def validate_exchange_market
    @current_exchange = Exchange.friendly.find(params[:exchange])
    @current_market = current_exchange.markets.friendly.find(params[:market])

    raise ActiveRecord::RecordNotFound if current_market.nil?
  end

end
