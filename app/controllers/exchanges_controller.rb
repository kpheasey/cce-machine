class ExchangesController < ApplicationController

  def index

  end

  def show
    @exchange = Exchange.friendly.find(params[:id])
    @market = Market.friendly.find(params[:market])
    @asks = Order::Ask.where(exchange: @exchange, market: @market).latest.limit(10)
    @bids = Order::Bid.where(exchange: @exchange, market: @market).latest.limit(10)
  end

end
