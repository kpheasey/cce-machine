class MarketsController < ApplicationController

  def index

  end

  def show
    @market = Market.friendly.includes(:exchanges).find(params[:id])
    @exchanges = @market.exchanges
  end

end
