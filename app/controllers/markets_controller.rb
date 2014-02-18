class MarketsController < ApplicationController
  layout 'trading_floor'


  def show
    @market = Market.friendly.includes(:exchanges).find(params[:id])
    @exchanges = @market.exchanges
  end

end
